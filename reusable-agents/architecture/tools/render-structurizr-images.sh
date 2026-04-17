#!/usr/bin/env bash
set -euo pipefail

# Render PNG images from a Structurizr DSL workspace and write a manifest.
# Usage:
#   render-structurizr-images.sh <workspace.dsl> [output-dir]

WORKSPACE_DSL="${1:-}"
OUTPUT_DIR="${2:-}"

if [[ -z "$WORKSPACE_DSL" ]]; then
  echo "Usage: $0 <workspace.dsl> [output-dir]" >&2
  exit 2
fi

if [[ ! -f "$WORKSPACE_DSL" ]]; then
  echo "Structurizr DSL not found: $WORKSPACE_DSL" >&2
  exit 2
fi

if [[ -z "$OUTPUT_DIR" ]]; then
  OUTPUT_DIR="$(dirname "$WORKSPACE_DSL")/rendered"
fi

mkdir -p "$OUTPUT_DIR"

run_export() {
  local runner="$1"

  case "$runner" in
    structurizr)
      structurizr export -workspace "$WORKSPACE_DSL" -format png -output "$OUTPUT_DIR"
      ;;
    structurizr-cli)
      structurizr-cli export -workspace "$WORKSPACE_DSL" -format png -output "$OUTPUT_DIR"
      ;;
    jar)
      if [[ -z "${STRUCTURIZR_CLI_JAR:-}" || ! -f "${STRUCTURIZR_CLI_JAR:-}" ]]; then
        return 1
      fi
      java -jar "$STRUCTURIZR_CLI_JAR" export -workspace "$WORKSPACE_DSL" -format png -output "$OUTPUT_DIR"
      ;;
    *)
      return 1
      ;;
  esac
}

attempt_order=(structurizr structurizr-cli jar)
render_ok=0

for runner in "${attempt_order[@]}"; do
  if [[ "$runner" == "structurizr" ]] && ! command -v structurizr >/dev/null 2>&1; then
    continue
  fi

  if [[ "$runner" == "structurizr-cli" ]] && ! command -v structurizr-cli >/dev/null 2>&1; then
    continue
  fi

  if run_export "$runner"; then
    render_ok=1
    break
  fi
done

if [[ "$render_ok" -ne 1 ]]; then
  cat >&2 <<'EOF'
Unable to render Structurizr PNG images.
Install Structurizr CLI and expose it as `structurizr` or `structurizr-cli`,
or set STRUCTURIZR_CLI_JAR to a local structurizr-cli jar file path.
EOF
  exit 1
fi

png_files=()
while IFS= read -r file_path; do
  png_files+=("$file_path")
done < <(find "$OUTPUT_DIR" -maxdepth 1 -type f -name '*.png' | sort)

png_count="${#png_files[@]}"

if [[ "$png_count" -eq 0 ]]; then
  echo "Render command completed but no PNG files were generated in: $OUTPUT_DIR" >&2
  exit 1
fi

manifest_path="$OUTPUT_DIR/render-manifest.json"
{
  echo "{"
  echo "  \"workspace\": \"$WORKSPACE_DSL\","
  echo "  \"output_dir\": \"$OUTPUT_DIR\","
  echo "  \"rendered_at\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\","
  echo "  \"png_count\": $png_count,"
  echo "  \"files\": ["

  for i in "${!png_files[@]}"; do
    file_name="$(basename "${png_files[$i]}")"
    if [[ "$i" -lt $((png_count - 1)) ]]; then
      echo "    \"$file_name\","
    else
      echo "    \"$file_name\""
    fi
  done

  echo "  ]"
  echo "}"
} >"$manifest_path"

echo "Rendered $png_count PNG file(s) to: $OUTPUT_DIR"
echo "Manifest: $manifest_path"
