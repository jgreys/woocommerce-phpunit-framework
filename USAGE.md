# Usage Guide

Complete guide to using the WooCommerce PHPUnit Framework in your tests.

## Table of Contents

- [Basic Usage](#basic-usage)
- [Base Test Cases](#base-test-cases)
- [Helper Classes](#helper-classes)
- [Mock Classes](#mock-classes)
- [Traits](#traits)
- [Advanced Examples](#advanced-examples)

---

## Basic Usage

### Simple Product Test

```php
<?php
class My_Product_Test extends WC_Unit_Test_Case {

    public function test_product_creation() {
        $product = WC_Helper_Product::create_simple_product();

        $this->assertInstanceOf('WC_Product', $product);
        $this->assertTrue($product->get_id() > 0);
    }

    public function test_product_price() {
        $product = WC_Helper_Product::create_simple_product();
        $product->set_regular_price(100);
        $product->save();

        $this->assertEquals(100, $product->get_regular_price());
    }
}
```

### Order Test

```php
<?php
class My_Order_Test extends WC_Unit_Test_Case {

    public function test_order_creation() {
        $order = WC_Helper_Order::create_order();

        $this->assertInstanceOf('WC_Order', $order);
        $this->assertTrue($order->get_id() > 0);
    }

    public function test_order_total() {
        $order = WC_Helper_Order::create_order();

        $this->assertGreaterThan(0, $order->get_total());
    }
}
```

---

## Base Test Cases

### WC_Unit_Test_Case

Base test case for all WooCommerce tests. Extends `WP_HTTP_TestCase`.

```php
<?php
class My_Extension_Test extends WC_Unit_Test_Case {

    public function setUp() {
        parent::setUp();
        // Your setup code
    }

    public function tearDown() {
        // Your cleanup code
        parent::tearDown();
    }

    public function test_something() {
        // Your test
    }
}
```

**Features:**
- WooCommerce-specific setup/teardown
- Factory access via `$this->factory`
- Custom assertions

### WC_REST_Unit_Test_Case (v2.0+)

For testing REST API endpoints.

```php
<?php
class My_REST_API_Test extends WC_REST_Unit_Test_Case {

    public function test_custom_endpoint() {
        $request = new WP_REST_Request('GET', '/wc/v3/my-endpoint');
        $request->set_param('id', 123);

        $response = $this->server->dispatch($request);

        $this->assertEquals(200, $response->get_status());

        $data = $response->get_data();
        $this->assertArrayHasKey('id', $data);
    }

    public function test_endpoint_authentication() {
        wp_set_current_user(0); // Logout

        $request = new WP_REST_Request('POST', '/wc/v3/my-endpoint');
        $response = $this->server->dispatch($request);

        $this->assertEquals(401, $response->get_status());
    }
}
```

### WC_API_Unit_Test_Case

For testing legacy WooCommerce API.

```php
<?php
class My_Legacy_API_Test extends WC_API_Unit_Test_Case {

    public function test_legacy_api_endpoint() {
        // Legacy API tests
    }
}
```

---

## Helper Classes

### WC_Helper_Product

Create test products.

```php
<?php
// Simple product
$product = WC_Helper_Product::create_simple_product();

// Simple product with options
$product = WC_Helper_Product::create_simple_product(true, array(
    'name' => 'Test Product',
    'price' => '29.99',
    'sku' => 'TEST-SKU-001'
));

// Variable product
$variable_product = WC_Helper_Product::create_variation_product();

// External product
$external = WC_Helper_Product::create_external_product();

// Grouped product
$grouped = WC_Helper_Product::create_grouped_product();
```

### WC_Helper_Order

Create test orders.

```php
<?php
// Basic order
$order = WC_Helper_Order::create_order();

// Order with specific customer
$customer_id = 1;
$order = WC_Helper_Order::create_order($customer_id);

// Order with specific product
$product = WC_Helper_Product::create_simple_product();
$order = WC_Helper_Order::create_order($customer_id, $product);

// Access order properties
$total = $order->get_total();
$items = $order->get_items();
```

### WC_Helper_Customer

Create test customers.

```php
<?php
// Create customer
$customer = WC_Helper_Customer::create_customer();

// Create customer with specific username
$customer = WC_Helper_Customer::create_customer('testuser', 'password', 'test@example.com');

// Update customer
$customer->set_billing_city('New York');
$customer->save();
```

### WC_Helper_Coupon

Create test coupons.

```php
<?php
// Basic coupon
$coupon = WC_Helper_Coupon::create_coupon();

// Percentage discount coupon
$coupon = WC_Helper_Coupon::create_coupon('save20');
$coupon->set_discount_type('percent');
$coupon->set_amount(20);
$coupon->save();

// Fixed discount coupon
$coupon = WC_Helper_Coupon::create_coupon('save10');
$coupon->set_discount_type('fixed_cart');
$coupon->set_amount(10);
$coupon->save();
```

### WC_Helper_Shipping

Shipping helpers.

```php
<?php
// Set up shipping
WC_Helper_Shipping::create_simple_flat_rate();
WC_Helper_Shipping::force_customer_us_address();
```

### WC_Helper_Fee

Fee helpers.

```php
<?php
WC_Helper_Fee::add_cart_fee();
```

### WC_Helper_Queue (v5.0+)

Action queue testing.

```php
<?php
// Get queue instance
$queue = WC_Helper_Queue::get_queue();

// Test scheduled actions
WC_Helper_Queue::run_all_pending();
```

### WC_Helper_Admin_Notes (v5.0+)

Admin notes testing.

```php
<?php
$note = WC_Helper_Admin_Notes::create_note();
```

---

## Mock Classes

### WC_Mock_Session_Handler

Mock session for testing.

```php
<?php
class My_Session_Test extends WC_Unit_Test_Case {

    public function test_session() {
        $session = new WC_Mock_Session_Handler();
        $session->set('test_key', 'test_value');

        $this->assertEquals('test_value', $session->get('test_key'));
    }
}
```

### WC_Mock_Payment_Gateway (v2.0+)

Mock payment gateway.

```php
<?php
class My_Payment_Test extends WC_Unit_Test_Case {

    public function test_payment_processing() {
        $gateway = new WC_Mock_Payment_Gateway();
        $order = WC_Helper_Order::create_order();

        $result = $gateway->process_payment($order->get_id());

        $this->assertArrayHasKey('result', $result);
        $this->assertEquals('success', $result['result']);
    }
}
```

### WC_Mock_WC_Data (v2.0+)

Mock WooCommerce data object.

```php
<?php
$mock_data = new WC_Mock_WC_Data();
```

### WC_Dummy_Data_Store (v2.0+)

Dummy data store for testing.

```php
<?php
$data_store = new WC_Dummy_Data_Store();
```

---

## Traits

### Trait_WC_REST_API_Complex_Meta (v3.0+)

For testing REST API with complex meta data.

```php
<?php
class My_Complex_Meta_Test extends WC_REST_Unit_Test_Case {
    use Trait_WC_REST_API_Complex_Meta;

    public function test_complex_meta() {
        // Test complex meta handling
    }
}
```

---

## Advanced Examples

### Testing Custom Post Types

```php
<?php
class My_CPT_Test extends WC_Unit_Test_Case {

    public function test_custom_product_type() {
        $product = new WC_Product_Custom();
        $product->set_name('Custom Product');
        $product->save();

        $this->assertEquals('custom', $product->get_type());
    }
}
```

### Testing Hooks and Filters

```php
<?php
class My_Hook_Test extends WC_Unit_Test_Case {

    public function test_product_price_filter() {
        $product = WC_Helper_Product::create_simple_product();
        $product->set_regular_price(100);

        add_filter('woocommerce_product_get_price', function($price) {
            return $price * 0.9; // 10% discount
        });

        $this->assertEquals(90, $product->get_price());
    }
}
```

### Testing AJAX Endpoints

```php
<?php
class My_AJAX_Test extends WC_Unit_Test_Case {

    public function test_ajax_add_to_cart() {
        $product = WC_Helper_Product::create_simple_product();

        $_POST['product_id'] = $product->get_id();
        $_POST['quantity'] = 1;

        try {
            $this->_handleAjax('woocommerce_add_to_cart');
        } catch (WPAjaxDieContinueException $e) {
            // Expected
        }

        $this->assertNotEmpty(WC()->cart->get_cart());
    }
}
```

### Testing Email Notifications

```php
<?php
class My_Email_Test extends WC_Unit_Test_Case {

    public function test_order_email() {
        $order = WC_Helper_Order::create_order();

        $emails = WC()->mailer()->get_emails();
        $email = $emails['WC_Email_Customer_Processing_Order'];

        $email->trigger($order->get_id());

        // Assert email was sent
        $this->assertTrue($email->is_enabled());
    }
}
```

### Testing Database Queries

```php
<?php
class My_Query_Test extends WC_Unit_Test_Case {

    public function test_product_query() {
        WC_Helper_Product::create_simple_product();
        WC_Helper_Product::create_simple_product();

        $query = new WC_Product_Query(array(
            'limit' => -1,
            'return' => 'ids',
        ));

        $products = $query->get_products();

        $this->assertCount(2, $products);
    }
}
```

---

## Tips & Best Practices

### Clean Up After Tests

```php
<?php
public function tearDown() {
    // Clean up products
    WC()->product_factory = null;

    // Clean cart
    WC()->cart->empty_cart();

    parent::tearDown();
}
```

### Use Data Providers

```php
<?php
/**
 * @dataProvider price_provider
 */
public function test_product_prices($regular, $sale, $expected) {
    $product = WC_Helper_Product::create_simple_product();
    $product->set_regular_price($regular);
    $product->set_sale_price($sale);

    $this->assertEquals($expected, $product->get_price());
}

public function price_provider() {
    return array(
        array(100, 80, 80),   // Regular 100, Sale 80, expect 80
        array(100, '', 100),  // Regular 100, no sale, expect 100
        array(50, 40, 40),    // Regular 50, Sale 40, expect 40
    );
}
```

### Mock External APIs

```php
<?php
public function test_external_api() {
    add_filter('pre_http_request', function($response, $args, $url) {
        if (strpos($url, 'api.example.com') !== false) {
            return array(
                'response' => array('code' => 200),
                'body' => json_encode(array('success' => true))
            );
        }
        return $response;
    }, 10, 3);

    // Test code that calls external API
}
```

---

For version-specific features, see [VERSIONS.md](VERSIONS.md).
