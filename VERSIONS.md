# Framework Versions

Complete guide to all WooCommerce PHPUnit Framework versions to help you choose the right one for your project.

## Quick Reference

Choose your framework version based on your WooCommerce version:

| Framework | WooCommerce | Install | Files | What's New |
|-----------|-------------|---------|-------|------------|
| **v1.0** | 2.2 - 2.6 | `^1.0` | 6 | Basic framework |
| **v2.0** | 3.0 - 4.1 | `^2.0` | 20 | +REST API, helpers |
| **v3.0** | 4.2 - 5.9 | `^3.0` | 21 | +Traits |
| **v4.0** | 6.0 - 6.4 | `^4.0` | 21 | Monorepo (same features as v3.0) |
| **v5.0** | 6.5+ | `^5.0` | 26 | +Enhanced payments, queue, admin notes |

**Installation:**
```bash
composer require --dev jgreys/woocommerce-phpunit-framework:^5.0
```

---

## Framework Version 1.x

### Supported WooCommerce Versions
- **Range:** 2.2.0 - 2.6.14
- **Representative tag:** `2.6.14`
- **Path:** `tests/framework/`

### Files (6 total)
```
tests/framework/
├── class-wc-api-unit-test-case.php
├── class-wc-mock-session-handler.php
├── class-wc-unit-test-case.php
├── class-wc-unit-test-factory.php
└── factories/
    ├── class-wc-unit-test-factory-for-webhook-delivery.php
    └── class-wc-unit-test-factory-for-webhook.php
```

### Key Features
- Basic test case classes
- Session mocking
- Factory pattern for test data
- Webhook support

---

## Framework Version 2.x

### Supported WooCommerce Versions
- **Range:** 3.0.0 - 4.1.4
- **Representative tag:** `4.1.4`
- **Path:** `tests/framework/`

### Files (20 total)
```
tests/framework/
├── class-wc-api-unit-test-case.php
├── class-wc-dummy-data-store.php
├── class-wc-mock-payment-gateway.php
├── class-wc-mock-session-handler.php
├── class-wc-mock-wc-data.php
├── class-wc-mock-wc-object-query.php
├── class-wc-payment-token-stub.php
├── class-wc-rest-unit-test-case.php
├── class-wc-unit-test-case.php
├── class-wc-unit-test-factory.php
├── helpers/
│   ├── class-wc-helper-coupon.php
│   ├── class-wc-helper-customer.php
│   ├── class-wc-helper-fee.php
│   ├── class-wc-helper-order.php
│   ├── class-wc-helper-payment-token.php
│   ├── class-wc-helper-product.php
│   ├── class-wc-helper-settings.php
│   ├── class-wc-helper-shipping-zones.php
│   └── class-wc-helper-shipping.php
└── vendor/
    └── class-wp-test-spy-rest-server.php
```

### Key Features
- **NEW:** REST API test case support
- **NEW:** Comprehensive helper classes for creating test data
- **NEW:** Mock classes for data stores and queries
- Payment gateway mocking
- Payment token support

### Changes from v1.x
- Added 14 new files
- Major expansion of test helpers
- REST API support introduced

---

## Framework Version 3.x

### Supported WooCommerce Versions
- **Range:** 4.2.0 - 5.9.1
- **Representative tag:** `5.9.1`
- **Path:** `tests/legacy/framework/`

### Files (21 total)
Same as v2.x (20 files), plus:
```
tests/legacy/framework/
└── traits/
    └── trait-wc-rest-api-complex-meta.php
```

### Key Features
- All features from v2.x
- **NEW:** REST API complex meta support via trait

### Changes from v2.x
- **PATH CHANGE:** Moved from `tests/framework/` to `tests/legacy/framework/`
- Added 1 new file (trait for complex meta handling)
- Framework designated as "legacy" in preparation for new test structure

---

## Framework Version 4.x

### Supported WooCommerce Versions
- **Range:** 6.0.0 - 6.4.1
- **Representative tag:** `6.4.1`
- **Path:** `plugins/woocommerce/tests/legacy/framework/`

### Files (21 total)
Identical to v3.x files, just in a new location

### Key Features
- Same functionality as v3.x
- Monorepo structure

### Changes from v3.x
- **PATH CHANGE:** Moved from `tests/legacy/framework/` to `plugins/woocommerce/tests/legacy/framework/`
- No functional changes, only organizational (monorepo migration)

---

## Framework Version 5.x

### Supported WooCommerce Versions
- **Range:** 6.5.0+
- **Representative tag:** `9.0.0` (stable) or latest
- **Path:** `plugins/woocommerce/tests/legacy/framework/`

### Files (26 total)
Same as v4.x (21 files), plus:
```
plugins/woocommerce/tests/legacy/framework/
├── class-wc-mock-enhanced-payment-gateway.php
└── helpers/
    ├── class-wc-helper-admin-notes.php
    ├── class-wc-helper-queue.php
    ├── class-wc-helper-reports.php
    └── class-wc-test-action-queue.php
```

### Complete File List
```
plugins/woocommerce/tests/legacy/framework/
├── class-wc-api-unit-test-case.php
├── class-wc-dummy-data-store.php
├── class-wc-mock-enhanced-payment-gateway.php         [NEW in 5.x]
├── class-wc-mock-payment-gateway.php
├── class-wc-mock-session-handler.php
├── class-wc-mock-wc-data.php
├── class-wc-mock-wc-object-query.php
├── class-wc-payment-token-stub.php
├── class-wc-rest-unit-test-case.php
├── class-wc-unit-test-case.php
├── class-wc-unit-test-factory.php
├── helpers/
│   ├── class-wc-helper-admin-notes.php                [NEW in 5.x]
│   ├── class-wc-helper-coupon.php
│   ├── class-wc-helper-customer.php
│   ├── class-wc-helper-fee.php
│   ├── class-wc-helper-order.php
│   ├── class-wc-helper-payment-token.php
│   ├── class-wc-helper-product.php
│   ├── class-wc-helper-queue.php                      [NEW in 5.x]
│   ├── class-wc-helper-reports.php                    [NEW in 5.x]
│   ├── class-wc-helper-settings.php
│   ├── class-wc-helper-shipping-zones.php
│   ├── class-wc-helper-shipping.php
│   └── class-wc-test-action-queue.php                 [NEW in 5.x]
├── traits/
│   └── trait-wc-rest-api-complex-meta.php
└── vendor/
    └── class-wp-test-spy-rest-server.php
```

### Key Features
- All features from v4.x
- **NEW:** Enhanced payment gateway mocking
- **NEW:** Admin notes testing helpers
- **NEW:** Queue and action testing helpers
- **NEW:** Reports testing helpers

### Changes from v4.x
- Added 5 new files
- Enhanced payment gateway support
- Better admin and queue testing capabilities

---

## Version Timeline

```
WC 2.2 ──┬──────────────────────┬─── Framework v1.x (6 files)
WC 2.6 ──┘                       │   tests/framework/
                                 │
WC 3.0 ──┬──────────────────────┬─── Framework v2.x (20 files)
WC 4.1 ──┘                       │   tests/framework/
                                 │
WC 4.2 ──┬──────────────────────┬─── Framework v3.x (21 files)
WC 5.9 ──┘                       │   tests/legacy/framework/
                                 │
WC 6.0 ──┬──────────────────────┬─── Framework v4.x (21 files)
WC 6.4 ──┘                       │   plugins/woocommerce/tests/legacy/framework/
                                 │
WC 6.5 ──┬──────────────────────┬─── Framework v5.x (26 files)
WC 10.2 ─┘                       │   plugins/woocommerce/tests/legacy/framework/
```

---

## Package Maintainer Guide

This section is for maintainers of this package.

### Reference Tags

When creating/updating framework versions, use these WooCommerce tags:

| Framework | WooCommerce Tag | Command |
|-----------|----------------|---------|
| v1.0.x | `2.6.14` | `./bin/update-framework.sh 2.6.14` |
| v2.0.x | `4.1.4` | `./bin/update-framework.sh 4.1.4` |
| v3.0.x | `5.9.1` | `./bin/update-framework.sh 5.9.1` |
| v4.0.x | `6.4.1` | `./bin/update-framework.sh 6.4.1` |
| v5.0.x | `9.0.0` (or latest) | `./bin/update-framework.sh 9.0.0` |

### Creating All Tags

```bash
# Install jq
brew install jq  # macOS
# or
sudo apt-get install jq  # Ubuntu

# Interactive tag creator
chmod +x bin/*.sh
./bin/create-all-tags.sh

# Push to GitHub
git push origin main --tags
```

### Updating an Existing Version

```bash
# Update src/ with new WC version
./bin/update-framework.sh 9.1.0

# Commit and create patch version
git add .
git commit -m "Update framework from WC 9.1.0"
git tag -a v5.0.1 -m "Update framework from WC 9.1.0"
git push origin v5.0.1
```

GitHub Actions will automatically create a release and update Packagist.
