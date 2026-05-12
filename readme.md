# eSputnik OpenCart App

OpenCart app for integrating eSputnik with OpenCart.

## Purpose

The purpose of the plugin is to simplify the integration of OpenCart-based online stores with the eSputnik platform and to provide all the necessary functionality without manual code intervention.

The plugin implements:

* Automatic transfer of current and historical customer data (contacts) from OpenCart to eSputnik — including creation, deletion and update
* Automatic transfer of current and historical order data from OpenCart to eSputnik — including creation and updates
* Automatic registration of the store domain in eSputnik (to obtain general and web push scripts)
* Automatic installation of the required scripts (site tracking, web push) and the service worker for push notifications on the site
* Web tracking configuration for collecting user activity on the site (product page views, cart updates, purchases, etc.)
* App Inbox script initialization and authentication token retrieval when the App Inbox toggle is enabled. 
* Logging of errors and export status

---

## Plugin Installation

### Installation Steps

1. Download the latest `esputnik.ocmod.zip` from the Releases page.
2. Log in to your OpenCart Admin Panel.
3. Navigate to **Extensions → Extension Installer**, click **Upload**, and select the downloaded file. Wait for the success message.
4. Go to **Extensions → Modifications** and click the **Refresh** button (top right corner) to rebuild the cache and apply event hooks.
5. Navigate to **Extensions → Extensions**, choose **Modules** from the dropdown list.
6. Find **eSputnik CDP** in the list and click the green **Install** button.
7. Click **Edit**.
8. Enter your **Full Access to API** key from your eSputnik account and click **Synchronize**.

### Auto-Recovery Mechanism & UI

Once the API key is validated, the UI instantly triggers three asynchronous AJAX processes in parallel:

* **Web Tracking Configuration** (`getSiteScript`) - domain registration and tracking script retrieval
* **Web Push Configuration** (`addWebPush`) - domain registration, script and service worker retrieval
* **Historical Data Import** (`loadCustomers` and `loadOrders`) - bulk export of contacts and orders

Each process has an automatic retry mechanism. If a request fails or times out, the system retries automatically up to **5 times** with a 3-second delay between attempts. If all retries are exhausted, the process halts and a **Try Again** button is displayed, allowing the administrator to resume the exact failed step without restarting the entire configuration. The system records an error in the integration log.

**Live Status Tracking:** The interface transforms into a live dashboard, displaying real-time progress indicators (spinners, success checkmarks, or error icons) for each individual step. It dynamically tracks the total number of contacts and orders synced, updating the success and failure counts on the fly.

---

## Plugin Authorization

Authorization is performed using the eSputnik API Key entered in the plugin settings.

**Method:** `GET /api/v1/account/info`

* **Trigger:** User enters the API Key and clicks **Synchronize**.
* **Happy Flow:** The API returns account metadata including `orgId` and `organisationName`. The plugin saves these credentials to OpenCart's settings and triggers the automated setup sequence. The system logs a success event.

---

## Automated Web Tracking Setup

### Step 1: Domain Registration

**Method:** `POST /api/v1/site/domains`

* **Payload:** The plugin sends the store's domain.
* **Happy Flow:** The domain is successfully registered, the system logs a success event and the API returns a unique Site ID.

### Step 2: Script Retrieval & Implementation

**Method:** `GET /api/v1/site/script`

* **Trigger:** Initiated immediately upon successful domain registration.
* **Happy Flow:** The API returns the tracking script, which is dynamically injected after the storefront's `<body>` tag via OpenCart's OCMOD. The system logs a success event.

---

## Automated Web Push Setup

### Step 1: Domain Registration

**Method:** `POST /api/v1/site/webpush/domain`

* **Payload:** The plugin sends the store's domain, `serviceWorkerName` (e.g., `sw-esputnik.js`), `serviceWorkerScope` (typically `/`), and the `serviceWorkerPath` (same as `serviceWorkerScope`).
* **Happy Flow:** The domain is registered successfully. The system logs a success event.

### Step 2: Script & Service Worker Retrieval

**Method:** `GET /api/v1/site/webpush/script`

* **Trigger:** Initiated immediately upon successful domain registration.
* **Happy Flow:** The API returns both the HTML script snippet and the raw JavaScript content for the Service Worker. The system logs a success event.

### Step 3: Implementation & File Generation

* **Service Worker Placement:** The plugin automatically creates the physical Service Worker file and saves it to the root directory of the OpenCart installation.
* **HTML Injection:** The retrieved script is dynamically injected after the storefront's `<body>` tag via OCMOD, enabling the native push subscription prompt.

---

## Contact Synchronization

### Real-Time Synchronization

**Methods:** `POST /api/v1/contact` (Create/Update) and `DELETE /api/v1/contact` (Delete)

* **Trigger:** OpenCart hooks `customer/addCustomer/after`, `customer/editCustomer/after`, `customer/deleteCustomer/after`.
* **Payload:** Mapped object containing `externalCustomerId`, `firstName`, `lastName`, and `channels` (email, sanitized SMS phone number).
* **Admin Deletion:** When a contact is deleted, the `DELETE` method is called with `erase => true` to ensure complete removal.

### Bulk (Historical) Synchronization

**Method:** `POST /api/v1/contacts` (Array Payload)

* **Trigger:** Historical data is loaded automatically during module installation.
* **Batch Size:** 2,000 contacts per request.
* **Batch Execution:** The next batch is sent immediately after the previous one completes.
* **Happy Flow:** Batches are accepted by the API and the result is logged.

---

## Order Synchronization

### Real-Time Synchronization

**Method:** `POST /api/v1/orders`

* **Trigger:** OpenCart event `checkout/order/addOrderHistory/after`.
* **Payload:** Object containing `externalOrderId`, `externalCustomerId`, `totalCost`, mapped order status, and an `items` array (`externalItemId`, `name`, `cost`, `quantity`).

### Bulk (Historical) Synchronization

**Method:** `POST /api/v1/orders` (Array Payload)

* **Trigger:** Historical data is loaded automatically during module installation.
* **Batch Size:** 300 orders per request.
* **Batch Execution:** The next batch is sent immediately after the previous one completes.
* **Happy Flow:** Orders are mapped and accepted, triggering the success log.

Status Mapping: Module translates OpenCart statuses (using `config_processing_status` and `config_complete_status`) to eSputnik equivalents for accurate RFM analysis and trigger campaigns.

---

## Web Tracking Events

### Backend Events

| Event | Trigger |
|---|---|
| `StatusCart` | Cart status change (add to cart, quantity update, item removal). Triggered via backend webhook `checkout/cart/add checkout/cart/remove checkout/cart/edit`. |
| `PurchasedItems` | Order completion. Triggered via backend webhook `model/checkout/order/addOrderHistory`. |
| `CustomerData` | Customer registration, login, or order placement. Links site visitors to contacts in eSputnik. Sent on any page after login and before `PurchasedItems`. |
| `AddToWishlist` | Product added to wishlist. Triggered via backend webhook `account/wishlist/add`. |

### Frontend Events

| Event | Trigger |
|---|---|
| `StatusCartPage` | Cart page viewed. |
| `MainPage` | Home page viewed. Required for on-site recommendations. |
| `NotFound` | 404 page reached. Required for on-site recommendations. |
| `ProductPage` | Product page viewed. Used for abandoned browse and discount notification campaigns. |
| `SearchRequest` | Search query submitted. |
| `CategoryPage` | Category page viewed. Used for recommendations of popular products in the browsed category. |

### Important Note on Product Variants

Across all tracking events, only the primary `product_id` is used. OpenCart's core architecture treats product options (e.g., size, color) as modifiers attached to a main product, rather than standalone entities with distinct IDs. Tracking specific option combinations individually or constructing a comprehensive product feed for every variant is not supported natively without significant custom modifications.

Prices and order totals reflect the actual amounts, including the selected variation. In recommendations and triggered campaigns, the product name, image, URL, and price are taken from the base product according to the feed.

---

## Data Mapping Reference

### Contact Field Mapping

| eSputnik Field | OpenCart Field | Notes |
|---|---|---|
| `externalCustomerId` | `customer_id` | Integer |
| `firstName` | `firstname` | |
| `lastName` | `lastname` | |
| `email` | `email` | Passed via `channels` array |
| `phone` | `telephone` | Non-numeric characters are stripped. Passed via `channels` array |

### Order Field Mapping

| eSputnik Field | OpenCart Field | Notes |
|---|---|---|
| `externalOrderId` | `order_id` | Integer |
| `externalCustomerId` | `customer_id` | Included only if `customer_id > 0` |
| `totalCost` | `total` | Formatted per OpenCart currency settings (without currency symbol) |
| `date` | `date_added` | Converted to UTC ISO 8601 format (`Y-m-d\TH:i:s\Z`) |
| `currency` | Config `config_currency` | Currency code (e.g., USD, EUR) |
| `email` | `email` | |
| `phone` | `telephone` | Non-numeric characters are stripped |
| `firstName` | `firstname` | |
| `lastName` | `lastname` | |
| `deliveryMethod` | `shipping_method` | |
| `paymentMethod` | `payment_method` | |

### Order Items Mapping

| eSputnik Field | OpenCart Field | Notes |
|---|---|---|
| `externalItemId` | `product_id` | Integer |
| `name` | `name` | |
| `quantity` | `quantity` | Integer |
| `cost` | `price` | Formatted per OpenCart currency settings (without currency symbol) |

### Order Status Mapping

| OpenCart Status Setting | eSputnik Status | Condition |
|---|---|---|
| None / Default | `INITIALIZED` | Fallback if the order does not match processing or complete statuses |
| Processing Statuses (`config_processing_status`) | `IN_PROGRESS` | Applies if `order_status_id` matches any status in the processing array |
| Complete Statuses (`config_complete_status`) | `DELIVERED` | Applies if `order_status_id` matches any status in the complete array |

---

## Logging & Status Tracking

The plugin UI displays real-time synchronization progress for both contacts and orders:

* `totalCount` — total number of records to synchronize.
* `syncedCount` — records successfully sent to eSputnik.
* `failedCount` — records rejected by eSputnik.

Final synchronization status:

* `COMPLETE` — all records processed successfully.
* `ERROR` — shown when a network failure or API error occurs during synchronization.

---

## Background Logging System

The plugin includes an isolated logging engine specifically for eSputnik API interactions. It silently captures all connectivity issues, data validation errors, and file generation faults without exposing them to the frontend user. This provides developers with an actionable audit trail for debugging without affecting the store's conversion rates.

---

## Self-Check and Adaptation of the eSputnik CDP Modifier

The eSputnik CDP module uses OCMOD technology to safely inject code into your store. Since the modifier file uses the error="skip" parameter, the system skips problematic paths without throwing a critical error if there is a conflict with your custom theme or other modules.

To make sure the integration works correctly, check whether all modifications were applied successfully and adapt them if needed.

### Step 1. Check the Log

1. In the admin panel, go to **Extensions -> Modifications**.
2. Click **Refresh** in the top-right corner.
3. Open the **Log** tab.
4. Press **Ctrl+F** and search for `esputnik_cdp` or the modifier name used in your build.
5. Carefully review the log entries related to this modifier. Look for the line: **NOT FOUND - OPERATIONS ABORTED!**
6. If you find this line, check the lines slightly above it in the log — they will usually show the exact file where the modifier could not find the required code fragment to replace.

### Step 2. Which files does the module modify?

If the log contains **NOT FOUND** errors, you need to understand which part of the integration is affected.

**Controller and model files (responsible for logic and data transfer):**

* `catalog/controller/common/header.php` — initializes scripts and events on most pages.
* `catalog/controller/product/product.php` — transfers product data such as price and stock status.
* `catalog/controller/checkout/cart.php` — handles add-to-cart events.
* `catalog/controller/account/wishlist.php` — handles wishlist events.
* `catalog/controller/product/search.php` — transfers search query data.
* `catalog/controller/product/category.php` — transfers category view data.
* `catalog/model/checkout/order.php` — transfers data after a successful order is placed.

**Template files (responsible for rendering scripts on `.tpl` or `.twig` pages):**

* `catalog/view/theme/*/template/common/header*` — outputs the base eSputnik scripts and usually searches for the `<body` tag.
* `catalog/view/theme/*/template/product/product*` — outputs scripts on product pages and usually searches for the footer output.
* `catalog/view/theme/*/template/product/search*` — outputs scripts on search pages.
* `catalog/view/theme/*/template/product/category*` — outputs scripts on category pages.

**Backend events triggered through OCMOD**

The module sends backend events through OCMOD by attaching logic to standard OpenCart routes and methods.

**`StatusCart`**
Sent through OCMOD when the cart changes:

* `checkout/cart/add`
* `checkout/cart/remove`
* `checkout/cart/edit`

**`PurchasedItems`**
Sent through OCMOD when the order history is updated:

* `model/checkout/order/addOrderHistory`

**`CustomerData`**
Sent through OCMOD:

* on any page after customer login;
* before `PurchasedItems` is sent.

**`AddToWishlist`**
Sent through OCMOD when a product is added to the wishlist:

* `account/wishlist/add`

This mapping helps you understand which route or method to check if a specific backend event is missing.

### Step 3. How to fix a `NOT FOUND` error manually

This error usually appears when the code fragment the modifier is searching for inside the `<search>` tag was changed by your theme developers or by another installed module.

**Example**

Suppose the log shows an error in the file:

`catalog/view/theme/*/template/common/header*.twig`

The modifier may be searching for this exact fragment:

`<body`

However, in your custom theme, the actual code may look different, for example:

`<body class="{{ class }}">`

In this case, the modifier cannot find the expected fragment and skips the operation.

**What you need to do**

1. Open the original store file indicated in the log via FTP or your hosting file manager.
2. Find the place where the code should be inserted. Use the file logic as a guide, for example after the `<body` tag or before the footer output.
3. Open the modifier file from the eSputnik module.
4. Find the `<file path="...">` block that corresponds to the problematic file.
5. Change the contents of the `<search><![CDATA[ ... ]]></search>` tag so that it matches the exact code fragment that actually exists in your theme file.
6. Save the changes to the modifier.
7. Upload the updated modifier through the admin panel, or replace the file manually if that matches your installation method.
8. Go back to **Extensions -> Modifications**, click **Refresh** again, and check the **Log**.

If everything was updated correctly, the **NOT FOUND** error should disappear.

**Tip**

If you do not want to edit the XML modifier, you can copy the code from the `<add>` tags and insert it into your theme files manually.

However, using **OCMOD** is the recommended approach because it helps preserve your integration when the theme is updated in the future.

---

## 🌿 Branch Structure

This project uses Git Flow workflow:

* `main` - Production-ready code, stable releases
* `dev` - Active development branch, all PRs should target this branch
* Feature branches - Created from `dev` for new features or fixes

---

## 🚀 Quick Start

1. Fork the Repository

```bash
# Fork on GitHub, then clone your fork
git clone git@github.com:ardas/esputnik-opencart.git
cd esputnik-opencart
# Switch to development branch
git checkout dev
```

2. Set Up Development Environment — follow the Installation Guide in [README.md](https://github.com/esputnik-CDP/esputnik-opencart/blob/main/readme.md) to install the module in your OpenCart development environment.

---

## 📝 Making Changes

### Branch Naming

* `feature/description` - for new features
* `fix/description` - for bug fixes
* `docs/description` - for documentation updates
* `refactor/description` - for code refactoring

### Commit Messages

Follow conventional commits:

```
type(scope): description

Example:
feat(sync): add support for new order status
fix(ui): resolve display issue in admin panel
docs(readme): update installation instructions
```

### Pull Request Process

1. Create a Feature Branch from `dev`

```bash
git checkout dev
git pull origin dev
git checkout -b feature/your-feature-name
```

2. Make Your Changes
   * Follow our [coding standards](https://github.com/esputnik-CDP/esputnik-opencart/blob/main/readme.md#-coding-standards)
   * Update documentation if needed

3. Validate Your Changes
   * Ensure your code follows OpenCart coding standards.
   * Test the module in your OpenCart installation (Admin and Catalog).
   * Ensure install.xml (OCMOD) works correctly and doesn't conflict with other extensions.

4. Submit Pull Request to `dev`
   * Push to your fork: `git push origin feature/your-feature-name`
   * Create a Pull Request targeting the `dev` branch with:
     * Clear title describing the change
     * Detailed description explaining:
       * What problem does this solve?
       * What changes were made?
       * How to test the changes?
     * Screenshots for UI changes
     * Link to related issues

---

## 🔧 Coding Standards

### OpenCart & PHP

* Follow the official [OpenCart Coding Standards](http://docs.opencart.com/en-gb/developer/coding-standards/).
* Use PHP 5.6+ compatible syntax (to maintain compatibility with older OpenCart versions).
* Follow OpenCart's MVC-L (Model-View-Controller-Language) architecture.
* Ensure all inputs are sanitized using OpenCart's `$this->db->escape()` or appropriate validation.
* Use OpenCart's built-in libraries (e.g., `$this->load->model()`, `$this->config->get()`).

### File Organization

The project follows the standard OpenCart structure:

```
src/
├── install.xml          # OCMOD modification file
└── upload/
    ├── admin/           # Admin panel files (Controller, Model, Language, View)
    ├── catalog/         # Frontend files (Controller, Model, Language, View)
    └── system/          # Library files and other system-level code
```

### Code Style

* Use Tabs for indentation (as per OpenCart standards).
* Follow PSR-1 and PSR-2 where it doesn't conflict with OpenCart standards.
* Use meaningful names for variables and functions.
* Add proper error handling and logging using OpenCart's `$this->log->write()`.

---

## 🐛 Bug Reports

Found a bug? Help us fix it by providing detailed information.

### Before Reporting

* Check if the issue already exists in GitHub Issues.
* Make sure you're using the latest version of the module.
* Try to reproduce the issue consistently.

### Bug Report Template

Use the GitHub bug report template when creating an issue. It should include steps to reproduce, environment details (OpenCart version, PHP version), and expected vs actual behavior.

---

## 💡 Feature Requests

Have an idea for improvement? We'd love to hear it!

### Feature Request Template

Use the GitHub feature request template when suggesting new features. Describe the problem it solves and how you envision the implementation.

---

## 🔒 Security

### Reporting Security Issues

Do not report security vulnerabilities through public GitHub issues.

Instead, please email us directly at: support@esputnik.com

Include:

* Description of the vulnerability
* Steps to reproduce
* Potential impact
* Suggested fix (if any)

### Security Guidelines for Contributors

* Never commit API keys, passwords, or secrets.
* Use OpenCart configuration/database for sensitive data, never hardcode.
* Validate all inputs and sanitize user data using OpenCart's security methods.
* Follow OWASP security practices.

---

## 🤝 Community Guidelines

### Code of Conduct

* Be respectful and inclusive.
* Focus on constructive feedback.
* Help newcomers feel welcome.
* Assume good intentions.
* No harassment or inappropriate behavior.

### Getting Help

* 📖 Check the [documentation](https://docs.esputnik.io/docs/integration-with-opencart)
* 💬 Ask questions in GitHub Discussions
* 📧 Contact us at support@esputnik.com
* 🐛 Report bugs through GitHub Issues

---

## 📊 Issue Management

### 🏷️ Labels We Use

| Label | Description | Used For |
|---|---|---|
| `bug` | Something isn't working | Bug reports |
| `feature` | New feature request | Feature requests |
| `enhancement` | Improvement to existing feature | Enhancements |
| `documentation` | Documentation needs update | Docs updates |
| `good first issue` | Good for newcomers | Beginner-friendly |
| `help wanted` | Extra attention needed | Community help |
| `question` | General questions | Q&A |
| `priority: critical` | Urgent fix needed | Critical bugs |
| `priority: high` | Should be fixed soon | Important issues |
| `priority: medium` | Normal priority | Standard issues |
| `priority: low` | Can wait | Minor issues |
| `status: waiting-for-feedback` | Needs more info | Pending response |
| `status: in-progress` | Being worked on | Active work |

---

## 📄 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](https://github.com/esputnik-CDP/esputnik-opencart/blob/main/LICENSE.txt) file for details.

---

Thank you for contributing to eSputnik OpenCart Integration! 🙏

Your contributions help make eSputnik better for everyone. Whether you're reporting bugs, suggesting features, or contributing code, every bit helps! 💙
