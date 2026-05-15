# E2E Test Patterns and Standards for Migration

This document provides detailed guidance on end-to-end (E2E) test patterns, anti-patterns, and standards for migration workflows. It complements the [E2E Test Assessment and Remediation Agent](e2e-test-assessment-remediation.agent.md) and the [Behaviour Baseline and Characterisation Testing Agent](behaviour-baseline-characterisation-testing.agent.md).

## Context and Principles

### What "E2E" Means Here

In the context of migration, **E2E tests** mean tests that verify **user journeys and API contracts** without coupling to internal implementation details. This is narrower than "true E2E" (full system end-to-end deployment) but broader than unit tests:

- **E2E in this context:** User/client makes observable requests (HTTP calls, navigation, form submission) → system processes → observable response (HTTP response, UI update, redirect, data rendered).
- **Not E2E for this purpose:** Tests that import internal services, mock internal DI containers, or assert on implementation logic that survives migration.
- **Key principle:** E2E tests must survive migration because they assert on observable boundaries, not on how the legacy implementation was constructed.

### Why Observable Behavior Matters

When you migrate from one technology stack to another (e.g., legacy monolith to microservices, or old JavaScript framework to React), the internal structure changes completely. Tests that depend on that structure will break and require rewriting. Observable-behavior tests do not:

- A test that says "when I POST to /api/users with {name, email}, I get back {id, name, email}" will work the same against both a legacy Express API and a new Go microservice API.
- A test that imports a `UserService` class and mocks its internal state will break on migration because the UserService may not exist in the target system.

---

## Test Pattern Hierarchy (Preference Order)

Apply patterns in this preference order. Use the highest-level pattern that produces a deterministic, implementation-independent assertion.

### 1. API Contract Test

**What it does:** Asserts the HTTP calls made and responses handled without importing or mocking the application's internal code.

**When to use:**
- Testing REST/GraphQL/other HTTP API endpoints.
- Testing HTTP error handling (4xx, 5xx status codes, error payloads).
- Testing API response structure and data serialization.
- Testing request header/authentication requirements.

**Example (Node.js + Jest):**

```javascript
// Test file: src/api/__tests__/users.e2e.test.ts
// Covers: product-features.md entry "User Registration"
// Covers: slice-001 "Auth: Add email verification step"

import fetch from 'node-fetch'; // or any HTTP client; no app module imports

describe('POST /api/users (User Registration API Contract)', () => {
  const baseURL = process.env.TEST_API_URL || 'http://localhost:3000';

  it('should return 201 with user object when valid payload provided', async () => {
    const response = await fetch(`${baseURL}/api/users`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        name: 'Alice',
        email: 'alice@example.com',
        password: 'secure123'
      })
    });

    expect(response.status).toBe(201);
    const user = await response.json();
    expect(user).toHaveProperty('id');
    expect(user).toHaveProperty('name', 'Alice');
    expect(user).toHaveProperty('email', 'alice@example.com');
    expect(user).not.toHaveProperty('password'); // Sensitive data not returned
  });

  it('should return 409 Conflict when email already exists', async () => {
    // Pre-condition: alice@example.com already registered
    const response = await fetch(`${baseURL}/api/users`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        name: 'Alice Again',
        email: 'alice@example.com',
        password: 'newpass123'
      })
    });

    expect(response.status).toBe(409);
    const error = await response.json();
    expect(error).toHaveProperty('message');
    expect(error.message).toContain('already exists');
  });

  it('should return 400 Bad Request when email format invalid', async () => {
    const response = await fetch(`${baseURL}/api/users`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        name: 'Bob',
        email: 'not-an-email',
        password: 'secure123'
      })
    });

    expect(response.status).toBe(400);
    const error = await response.json();
    expect(error).toHaveProperty('errors');
    expect(error.errors).toContainEqual(expect.objectContaining({ field: 'email' }));
  });
});
```

**Characteristics:**
- No internal module imports (no `import { UserService } from '../../services/user.service'`).
- No mocking of DI containers or application state.
- Uses public HTTP client or browser Fetch API.
- Asserts on observable HTTP contract (status, headers, response body structure).
- Survives migration: same test runs against legacy and target APIs.

**Deviation notes:**
- If the legacy system has no HTTP API and tests must use internal modules, document this as a deviation in baseline-evidence.md or e2e-readiness.md. Migration plan: create HTTP API in target or adapt test to use target's public interface.

---

### 2. Integration Test

**What it does:** Exercises a user-facing flow through the application's public entry points (URL navigation, form submission, event handling) with real or stubbed external dependencies. Does not import internal modules directly unless unavoidable.

**When to use:**
- Testing multi-step user flows (login → dashboard → profile update).
- Testing UI state changes and navigation in response to user actions.
- Testing form submission and validation feedback.
- Testing error handling and error messaging in UI.

**Example (Node.js + Supertest + Jest):**

```javascript
// Test file: src/__tests__/auth-flow.e2e.test.ts
// Covers: product-features.md entry "User login with valid credentials"
// Covers: slice-002 "Auth: Require 2FA for new devices"

import request from 'supertest';
import { app } from '../app'; // Import app factory, not internal services

describe('User Authentication Flow (Integration)', () => {
  let agent = request.agent(app);

  beforeEach(() => {
    // Reset agent for fresh session
    agent = request.agent(app);
  });

  it('should log in user and set session cookie', async () => {
    // Pre-condition: user alice@example.com already registered
    const response = await agent
      .post('/auth/login')
      .send({
        email: 'alice@example.com',
        password: 'secure123'
      });

    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('redirect', '/dashboard');
    
    // Verify session cookie was set
    expect(response.headers['set-cookie']).toBeDefined();
  });

  it('should deny login with invalid password', async () => {
    const response = await agent
      .post('/auth/login')
      .send({
        email: 'alice@example.com',
        password: 'wrongpassword'
      });

    expect(response.status).toBe(401);
    expect(response.body).toHaveProperty('message');
    expect(response.body.message).toContain('Invalid credentials');
    
    // Verify no session set
    expect(response.headers['set-cookie']).toBeUndefined();
  });

  it('should navigate to dashboard after login', async () => {
    // Login
    await agent
      .post('/auth/login')
      .send({
        email: 'alice@example.com',
        password: 'secure123'
      });

    // Access protected route
    const response = await agent.get('/dashboard');

    expect(response.status).toBe(200);
    expect(response.text).toContain('Welcome, Alice');
  });

  it('should require 2FA for new device (slice-002)', async () => {
    // Login from a new device
    const response = await request(app)
      .post('/auth/login')
      .set('User-Agent', 'Mozilla/5.0 (iPhone...') // Simulated new device
      .send({
        email: 'alice@example.com',
        password: 'secure123'
      });

    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('next_step', '2fa-verification');
    expect(response.body).toHaveProperty('verification_code_sent', true);
  });
});
```

**Characteristics:**
- Imports application factories or public routers, not internal service classes.
- Uses HTTP client or application testing utilities (Supertest, Cypress, etc.).
- Stubs external services (payment processor, auth provider) but exercises internal logic through public APIs.
- Asserts on observable outcomes: HTTP status, redirects, UI state, data rendered.
- Survives migration: same test works against target if public route contracts remain the same.

**Deviation notes:**
- If integration tests must import internal services to work, document why and mark as implementation-coupled. Plan for target: migrate test to use target's public interface or HTTP API.

---

### 3. User Journey Test

**What it does:** Sequences multiple user actions and assertions across application screens or API calls to verify a critical business flow end-to-end.

**When to use:**
- Testing critical user-facing workflows (checkout, account setup, file upload).
- Testing multi-step processes where intermediate state changes are important.
- Testing error recovery and retry scenarios.
- Testing workflows that cross multiple systems or boundaries.

**Example (Playwright):**

```javascript
// Test file: tests/e2e/checkout-flow.spec.ts
// Covers: product-features.md entries "Add items to cart", "Proceed to checkout", "Enter shipping address", "Complete payment"
// Covers: slice-003 "Checkout: Add promo code support"

import { test, expect } from '@playwright/test';

test.describe('Checkout User Journey', () => {
  test('should complete purchase flow with promo code (slice-003)', async ({ page }) => {
    // Step 1: Navigate to store
    await page.goto('https://example.com/store');
    expect(page.url()).toContain('/store');

    // Step 2: Add item to cart
    await page.click('[data-testid="product-coffee"]');
    await page.click('[data-testid="add-to-cart"]');
    await expect(page.locator('[data-testid="cart-count"]')).toContainText('1');

    // Step 3: Proceed to checkout
    await page.click('[data-testid="view-cart"]');
    await page.click('[data-testid="checkout-button"]');
    expect(page.url()).toContain('/checkout');

    // Step 4: Enter promo code (slice-003)
    await page.fill('[data-testid="promo-input"]', 'SAVE10');
    await page.click('[data-testid="apply-promo"]');
    await expect(page.locator('[data-testid="discount-amount"]')).toContainText('$10.00');
    await expect(page.locator('[data-testid="total-price"]')).toContainText('$40.00'); // $50 - $10

    // Step 5: Enter shipping address
    await page.fill('[data-testid="address-line1"]', '123 Main St');
    await page.fill('[data-testid="city"]', 'Portland');
    await page.fill('[data-testid="zip"]', '97201');
    await page.selectOption('[data-testid="state"]', 'OR');

    // Step 6: Confirm order
    await page.click('[data-testid="confirm-order"]');
    
    // Step 7: Verify success
    expect(page.url()).toContain('/order-confirmation');
    await expect(page.locator('[data-testid="order-number"]')).toBeVisible();
    const orderNumber = await page.locator('[data-testid="order-number"]').textContent();
    expect(orderNumber).toMatch(/^ORD-\d{6}$/);

    // Step 8: Verify order in backend (optional API verification)
    const response = await page.request.get(`/api/orders/${orderNumber}`);
    expect(response.status()).toBe(200);
    const order = await response.json();
    expect(order).toHaveProperty('promo_code', 'SAVE10');
    expect(order).toHaveProperty('discount_amount', 10.00);
    expect(order).toHaveProperty('total', 40.00);
  });

  test('should show error if promo code expired', async ({ page }) => {
    await page.goto('https://example.com/checkout');
    
    await page.fill('[data-testid="promo-input"]', 'EXPIRED99');
    await page.click('[data-testid="apply-promo"]');
    
    await expect(page.locator('[data-testid="promo-error"]')).toContainText('Promo code has expired');
    await expect(page.locator('[data-testid="discount-amount"]')).not.toBeVisible();
  });
});
```

**Characteristics:**
- Uses browser automation or HTTP client to simulate complete user sequence.
- Asserts at multiple checkpoints throughout the journey (navigation, state changes, data verification).
- Tests error recovery and alternative paths (e.g., expired promo code).
- Captures business-critical workflows; typically slower but highest value.
- Survives migration if test is structured around observable outcomes (URLs, UI text, data returned) not implementation internals.

**Deviation notes:**
- User journey tests often require sophisticated environment setup (database seeding, external service mocking). If environment is unavailable, defer and document risk.

---

### 4. Golden-Master / Snapshot Test

**What it does:** Captures deterministic rendered output (JSON structure, HTML structure, API response body) and versions it. Test fails if output changes unexpectedly.

**When to use:**
- Testing stable JSON/API response structures (rarely changed).
- Testing consistent HTML structure of critical UI components (headings, labels, form fields).
- Testing export formats (PDF headers, CSV columns).

**When NOT to use:**
- Dynamic content (timestamps, UUIDs, user-specific IDs).
- Content frequently updated by design.
- Business logic assertions better covered by direct assertions.

**Example (Jest snapshot):**

```javascript
// Test file: src/api/__tests__/product-list.snapshot.test.ts
// Covers: product-features.md entry "Fetch product list with filters"
// Covers: slice-004 "Products: Add 'in-stock' filter"

import request from 'supertest';
import { app } from '../../app';

describe('Product List API Snapshot Tests', () => {
  it('should return product list matching snapshot', async () => {
    const response = await request(app)
      .get('/api/products')
      .query({ category: 'coffee', in_stock: true }) // slice-004 filter
      .set('Accept', 'application/json');

    expect(response.status).toBe(200);
    
    // Snapshot assertion: captures structure, not values
    // NOTE: Review snapshot diff carefully before updating; prefer direct assertions
    expect(response.body).toMatchSnapshot();
  });
});

// Snapshot file: src/api/__tests__/__snapshots__/product-list.snapshot.test.ts.snap
/*
exports[`Product List API Snapshot Tests should return product list matching snapshot 1`] = `
{
  "products": [
    {
      "id": "prod-001",
      "name": "Ethiopian Highlands",
      "category": "coffee",
      "in_stock": true,
      "price": 12.99,
      "tags": ["single-origin", "medium-roast"]
    },
    {
      "id": "prod-002",
      "name": "Brazilian Santos",
      "category": "coffee",
      "in_stock": true,
      "price": 10.99,
      "tags": ["single-origin", "dark-roast"]
    }
  ],
  "page": 1,
  "total": 2,
  "limit": 10
}
`;
*/
```

**Characteristics:**
- Captures output structure (fields, types, nesting).
- Should NOT include dynamic values (IDs, timestamps) — mock or exclude them.
- Requires manual review of snapshot diffs; easy to accidentally weaken test.
- Use sparingly; prefer direct assertions where possible.
- Survives migration if snapshot structure aligns with target system's API contract.

**Deviation notes:**
- Snapshot tests can become brittle and high-maintenance if abused. Prefer API contract tests or integration tests where direct assertions are possible.

---

## Anti-Patterns (Avoid These)

### ❌ Implementation-Coupled Tests

**Bad:**
```javascript
// DO NOT DO THIS
import { UserService } from '../../services/user.service';
import { Database } from '../../db/database';

describe('User Registration (BAD)', () => {
  it('should create user in database', async () => {
    const service = new UserService(new Database());
    const user = await service.createUser({ email: 'alice@example.com' });
    expect(user.id).toBeDefined();
  });
});
```

**Why bad:**
- Imports internal service class; breaks on migration if service renamed/removed.
- Directly tests business logic, not observable behavior.
- Couples test to technology stack (specific ORM, database library).

**Better:**
```javascript
// DO THIS INSTEAD
describe('User Registration', () => {
  it('should create user and return 201 with user object', async () => {
    const response = await fetch('http://localhost:3000/api/users', {
      method: 'POST',
      body: JSON.stringify({ email: 'alice@example.com' })
    });
    expect(response.status).toBe(201);
    const user = await response.json();
    expect(user).toHaveProperty('id');
  });
});
```

### ❌ Hard-Coded Test Data

**Bad:**
```javascript
// DO NOT DO THIS
it('should fetch user by ID', async () => {
  const response = await fetch('http://localhost:3000/api/users/42');
  const user = await response.json();
  expect(user.id).toBe(42);
  expect(user.name).toBe('Alice');
});
```

**Why bad:**
- Test data is fragile; depends on specific database state.
- Fails if test database reset or record deleted.
- Not repeatable in different environments.

**Better:**
```javascript
// DO THIS INSTEAD
it('should fetch user by ID', async () => {
  // Create user first (or use test fixture)
  const createResp = await fetch('http://localhost:3000/api/users', {
    method: 'POST',
    body: JSON.stringify({ name: 'Alice', email: 'alice@example.com' })
  });
  const user = await createResp.json();
  const userId = user.id;

  // Now fetch and verify
  const response = await fetch(`http://localhost:3000/api/users/${userId}`);
  const fetched = await response.json();
  expect(fetched.id).toBe(userId);
  expect(fetched.name).toBe('Alice');
});
```

### ❌ Testing External Live Services

**Bad:**
```javascript
// DO NOT DO THIS
it('should send SMS via Twilio', async () => {
  const response = await request(app)
    .post('/api/send-sms')
    .send({ phone: '+1-555-1234', message: 'Hello' });
  // Test actually sends SMS via Twilio
  expect(response.status).toBe(200);
});
```

**Why bad:**
- Tests depend on external service availability.
- Slow and flaky.
- Costs money (Twilio charges per SMS).
- Cannot run offline or in isolated CI environment.

**Better:**
```javascript
// DO THIS INSTEAD
it('should send SMS via Twilio', async () => {
  // Mock the Twilio API
  jest.mock('twilio', () => ({
    Twilio: jest.fn(() => ({
      messages: { create: jest.fn().mockResolvedValue({ sid: 'SM123' }) }
    }))
  }));

  const response = await request(app)
    .post('/api/send-sms')
    .send({ phone: '+1-555-1234', message: 'Hello' });
  
  expect(response.status).toBe(200);
  // Verify that Twilio API was called with correct params
});
```

### ❌ Brittle Snapshot Tests

**Bad:**
```javascript
// DO NOT DO THIS
it('should render user dashboard', async () => {
  const response = await request(app)
    .get('/dashboard')
    .set('Cookie', 'session=abc123');
  
  // Snapshot captures entire HTML; fails if CSS class name changes
  expect(response.text).toMatchSnapshot();
});
```

**Why bad:**
- Snapshot includes everything; hard to review diffs.
- Breaks on cosmetic changes unrelated to functionality.
- Requires frequent snapshot updates; easy to accidentally weaken test.

**Better:**
```javascript
// DO THIS INSTEAD
it('should render user dashboard with user info', async () => {
  const response = await request(app)
    .get('/dashboard')
    .set('Cookie', 'session=abc123');
  
  expect(response.status).toBe(200);
  expect(response.text).toContain('Welcome, Alice');
  expect(response.text).toContain('alice@example.com');
  // Assert on meaningful content, not structure
});
```

---

## E2E Test Framework and Standards Selection (Preferences.md)

Each migration should define approved E2E test standards in `.github/migrations/<migration-id>/target/preferences.md` under an **E2E Section**:

### Template E2E Section for preferences.md

```yaml
# E2E Test Preferences

## Framework
- Primary: Jest + Supertest (for API contract tests + integration tests)
- UI/Browser: Playwright (for user journey tests)
- Rationale: Jest + Supertest handles HTTP testing well; Playwright handles browser automation

## Assertion Library
- HTTP tests: Jest built-in `expect()` + Supertest assertions
- Browser tests: Playwright built-in assertions (`expect()`)

## Test File Naming
- API contract tests: `src/{feature}/__tests__/{feature}.api-contract.test.ts`
- Integration tests: `src/{feature}/__tests__/{feature}.integration.test.ts`
- User journey tests: `tests/e2e/{feature}-flow.spec.ts`
- Snapshot tests: `src/{feature}/__tests__/{feature}.snapshot.test.ts`

## Test Folder Structure
- Unit/integration tests: Co-located `src/{feature}/__tests__/`
- E2E/browser tests: Top-level `tests/e2e/`
- Fixtures/test data: `tests/fixtures/`

## Environment Setup
- Test database: Docker container `postgres:14-alpine` with fixtures
- Mock services: `nock` library for HTTP mocking
- Test server: Start app in test mode on `http://localhost:3001`

## Known Flaky Tests
- (To be populated; known flaky tests registry)

## Coverage Thresholds
- E2E test coverage: At least 80% of critical user journeys
- Integration test coverage: At least 60% of public API endpoints
```

---

## Coverage Metrics and Reporting

### P6 Test Coverage Delta

Measure the change in E2E test coverage before and after a migration slice:

- **Before:** Run existing E2E test suite against legacy code; record pass count, coverage %.
- **After:** Run E2E test suite (existing + new) against target code; record pass count, coverage %.
- **Delta:** (After Coverage %) - (Before Coverage %) = coverage delta.
- **Evidence:** Coverage reports, test execution logs, changes to test file count.

**Metric Definition:**
- **P6 (Outcome):** Test coverage delta for E2E tests (critical path and integration boundaries).
- **Target:** +5 to +15 percentage points per slice (depends on initial coverage baseline and slice scope).
- **Interpretation:** Positive delta = more E2E coverage after migration; negative = lost coverage.

### P5 Change Failure Rate

Track whether E2E tests catch regressions in migration changes:

- **Before:** Baseline E2E test pass rate on legacy code.
- **After:** Run full E2E suite against target code after slice implemented.
- **Change Failure Rate:** (# E2E tests failing on target / # total E2E tests) × 100%.
- **Interpretation:** High CFR = slice introduced regressions; low CFR = migration held contract.

---

## Common E2E Test Failures and Diagnosis

### Problem: Test Passes in Local Environment, Fails in CI

**Causes:**
- Environment differences (different timezone, locale, database state).
- Hard-coded assumptions (localhost:3000 not available in CI).
- Missing CI setup (test database not initialized, mock services not running).
- Flaky timing (async operations not properly awaited).

**Remediation:**
- Use environment variables for URLs and credentials.
- Seed test database in CI setup step.
- Ensure mock services (Nock, etc.) started before tests.
- Add explicit waits/polls for async operations (Cypress/Playwright built-in retries).

### Problem: Snapshot Test Breaks on Unrelated Change

**Causes:**
- Snapshot includes too much detail (entire HTML structure).
- Cosmetic change (CSS class, field order) updated; snapshot not updated.

**Remediation:**
- Prefer direct assertions over snapshots.
- If snapshot required, use targeted snapshots (just the data structure, not styling).
- Review snapshot diffs carefully before updating; never auto-approve.

### Problem: E2E Test Flaky (Passes 80% of time)

**Causes:**
- Timing issues (wait for element that occasionally loads late).
- External service timeouts (mock service occasionally times out).
- Database state pollution (test leaves data affecting next test).
- Race conditions in async operations.

**Remediation:**
- Add explicit waits and retries (Playwright `expect()` retries automatically).
- Isolate tests with setup/teardown (fresh database per test or test fixture).
- Mock external services consistently; avoid live API calls.
- Use explicit `await` and async/await patterns; avoid `setTimeout`.

---

## Deferred E2E Coverage and Risk Acceptance

When high-risk E2E gaps cannot be remediated before Execution phase:

1. **Document gap clearly** in e2e-readiness.md:
   - Which slice(s) affected.
   - Which user journey or API contract uncovered.
   - Why gap exists (environment missing, prerequisite tests not yet written, etc.).
   - Risk: What can break before gap is covered?

2. **Propose risk mitigation**:
   - Manual testing before release (QA sign-off required).
   - Staged rollout (feature flag; test in production with rollback plan).
   - Priority remediation task in next phase.

3. **Human approval required**:
   - Orchestrator must wait for human approval of deferred risk before advancing Execution.
   - Approval must be recorded in tracker and state.yaml.

**Example deferred gap entry:**

```
## Deferred Gap: Payment Integration Error Recovery

**Slice:** slice-payment-001  
**Journey:** Checkout with payment processor timeout → user retries → payment succeeds  
**Why deferred:** Payment processor sandbox not accessible in CI environment; cannot mock without live credentials.  
**Risk:** If payment processor times out, user may not see retry option; could abandon checkout flow.  
**Mitigation:** Manual smoke test on staging environment before production release; payment team to sign off.  
**Timeline:** Address in Evaluate phase (post-launch); plan to automate payment integration tests in next cycle.  
**Owner:** QA Lead + Payment Team  
```

---

## References

- [E2E Test Assessment and Remediation Agent](e2e-test-assessment-remediation.agent.md)
- [Behaviour Baseline and Characterisation Testing Agent](behaviour-baseline-characterisation-testing.agent.md)
- [L4 Test for Change Requests](../../L4-Cannot-Meet-Current-or-Future-Business-Needs/L4-Tests-for-Change-Requests.md)
- [Metrics.md](../../Metrics.md) — P6 Test Coverage Delta, P5 Change Failure Rate
- [Migration Orchestrator](migration-orchestrator.agent.md) — Phase model and E2E Assessment checkpoint integration
