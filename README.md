# WooCommerce PHPUnit Framework

[![Packagist Version](https://img.shields.io/packagist/v/jgreys/woocommerce-phpunit-framework)](https://packagist.org/packages/jgreys/woocommerce-phpunit-framework)
[![License](https://img.shields.io/packagist/l/jgreys/woocommerce-phpunit-framework)](LICENSE)

Standalone WooCommerce PHPUnit testing framework. Test helpers, mock classes, and base test cases for WooCommerce extensions.

## Installation

```bash
composer require --dev jgreys/woocommerce-phpunit-framework:^5.0
```

### Version Selection

| Framework | WooCommerce | Command |
|-----------|-------------|---------|
| `^1.0` | 2.2 - 2.6 | `composer require --dev jgreys/woocommerce-phpunit-framework:^1.0` |
| `^2.0` | 3.0 - 4.1 | `composer require --dev jgreys/woocommerce-phpunit-framework:^2.0` |
| `^3.0` | 4.2 - 5.9 | `composer require --dev jgreys/woocommerce-phpunit-framework:^3.0` |
| `^4.0` | 6.0 - 6.4 | `composer require --dev jgreys/woocommerce-phpunit-framework:^4.0` |
| `^5.0` | 6.5+ | `composer require --dev jgreys/woocommerce-phpunit-framework:^5.0` |

See [VERSIONS.md](VERSIONS.md) for version details.

## Quick Start

```php
<?php
class My_Extension_Test extends WC_Unit_Test_Case {

    public function test_product_creation() {
        $product = WC_Helper_Product::create_simple_product();
        $this->assertInstanceOf('WC_Product', $product);
    }
}
```

## Documentation

- **[USAGE.md](USAGE.md)** - Usage guide with examples
- **[VERSIONS.md](VERSIONS.md)** - Version comparison and maintainer guide

## Links

- **Packagist:** https://packagist.org/packages/jgreys/woocommerce-phpunit-framework
- **GitHub:** https://github.com/jgreys/woocommerce-phpunit-framework
- **Issues:** https://github.com/jgreys/woocommerce-phpunit-framework/issues

## License

GPL-3.0-or-later

## Credits

Extracted from [WooCommerce](https://github.com/woocommerce/woocommerce). All credits to the WooCommerce team.
