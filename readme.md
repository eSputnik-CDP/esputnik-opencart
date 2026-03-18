# Esputnik CDP Integration for OpenCart

The official integration module for connecting OpenCart 2.3.x and 3.0.x stores with [Esputnik CDP](https://esputnik.com/). 

Unlike manual setups, this module is built on a **"Zero-Configuration"** architecture. Once you provide your API key, the module autonomously handles validation, injects web tracking, web push, and initiates parallel synchronization of your contacts and orders.

---

## ⚙️ API Architecture & Detailed Data Flow

This module is designed to work silently and efficiently in the background. Below is the detailed breakdown of all API methods, payloads, and error handling mechanisms.

### 1. API Key Validation & Initialization
* **Method:** `GET /api/v1/account/info`
* **Trigger:** User enters the API Key in the module settings and clicks "Synchronize".
* **Happy Flow:** The API returns account metadata including `orgId` and `organisationName`. The module saves these credentials to OpenCart's settings, updates the UI to confirm the connection, and triggers the `Add api key success` log.
* **Error Handling:** If validation fails (e.g., 401 Unauthorized), the synchronization halts immediately. The UI displays an error to the admin, and the system records an `Add api key error` in the dedicated integration log.

**UI Process Flow & Auto-Recovery Mechanism:**
Once the API key is successfully validated, the frontend interface orchestrates a fully automated setup sequence:
* **Parallel Execution:** The UI instantly triggers three asynchronous AJAX processes in parallel:
  1. Web Tracking Configuration (`getSiteScript`)
  2. Web Push Configuration (`addWebPush`)
  3. Historical Data Import (`loadCustomers` and `loadOrders`)
* **Live Status Tracking:** The interface transforms into a live dashboard, displaying real-time progress indicators (spinners, success checkmarks, or error icons) for each individual step. It dynamically tracks the total number of contacts and orders synced, updating the success and failure counts on the fly.
* **Automatic Retry (Auto-Recovery):** To handle temporary network hiccups or API rate limits, the frontend implements an automatic retry mechanism. If any process (tracking script retrieval, web push registration, or a specific data batch) fails or times out, the system automatically retries the failed request up to **5 times** (with a 3-second delay between attempts).
* **Manual Intervention:** If all 5 automatic retries are exhausted, the process halts, logs the final error, and presents a "Try Again" button. This allows the administrator to manually resume the exact failed step (e.g., resuming a historical data import from the exact page where it stopped) without restarting the entire configuration process.

### 2. Automated Web Tracking Setup
The module automatically configures Esputnik's Web Tracking capabilities through a sequential API flow.
* **Step 1: Domain Registration**
  * **Method:** `POST /api/v1/site/domains`
  * **Payload:** The plugin sends the store's `domain`.
  * **Happy Flow:** The domain is successfully registered, and the API returns a unique Site ID. The system logs an success event.
* **Step 2: Script Retrieval & Implementation**
  * **Method:** `GET /api/v1/site/script`
  * **Trigger:** Initiated immediately upon successful domain registration.
  * **Happy Flow:** The API returns the text of the tracking script. The script is then dynamically injected after the storefront's `<body>` tag via OpenCart's OCMOD.
* **Error Handling:** Failures at any stage are intercepted. The system logs specific errors. Even if the OCMOD injection fails, the storefront continues to operate normally without breaking frontend performance.
* **Behavioral Events & Triggers:** After successful configuration, the following events are automatically tracked:
  * *Backend Events:* `StatusCart`, `PurchasedItems`, `CustomerData`, `AddToWishlist`.
  * *Frontend Events:* `StatusCartPage`, `MainPage`, `NotFound`, `ProductPage`, `SearchRequest`, `CategoryPage`.

### 3. Automated Web Push Configuration
The module automatically configures Esputnik's Web Push capabilities through a sequential API flow.
* **Step 1: Domain Registration**
  * **Method:** `POST /api/v1/domain/web-push`
  * **Payload:** The plugin sends the store's `domain`, the intended `serviceWorkerName` (e.g., `sw-Esputnik.js`), and the `serviceWorkerScope` (typically `/`).
  * **Happy Flow:** If Esputnik successfully registers the domain, it logs an success event.
* **Step 2: Script & Service Worker Retrieval**
  * **Method:** `GET /api/v1/domain/web-push/script`
  * **Trigger:** Initiated immediately upon successful domain registration.
  * **Happy Flow:** The API returns both the HTML script snippet and the raw JavaScript content for the Service Worker.
* **Step 3: Implementation & File Generation**
  * **Service Worker Placement:** The plugin takes the raw Service Worker content returned by the API, automatically creates the physical file, and saves it directly to the root directory of your OpenCart installation.
  * **HTML Injection:** The retrieved script is dynamically injected after the storefront's `<body>` tag via OCMOD. This enables the native subscription prompt for visitors.
* **Error Handling:** Failures at any stage are intercepted. The system logs specific errors.

### 4. Contact Synchronization (Real-time & Bulk)
* **Real-time Methods:** `POST /api/v1/contact` (Create/Update) and `DELETE /api/v1/contact` (Delete).
	* **Trigger:** OpenCart's native hooks (`customer/addCustomer/after`, `customer/editCustomer/after`, `customer/deleteCustomer/after`).
	* **Payload:** Mapped object containing `externalCustomerId`, `firstName`, `lastName`, and `channels` (email, and sanitized SMS phone number).
	* **Admin Deletion:** When contacts are deleted by an administrator, they are processed via the `DELETE` method with the parameter `erase => true` to ensure complete removal.
* **Bulk Method:** `POST /api/v1/contacts`
	* **Trigger:** Background script using batched queries (`LIMIT/OFFSET`), executed periodically via Cron.
	* **Batch Size:** 2000 contacts per request.
	* **Batch Execution:** The next batch is sent immediately after the previous one completes.
	* **Happy Flow:** Batches are accepted by the API, logging success.
* **Error Handling:** Any malformed data, API timeouts, or rejection responses trigger a log, ensuring no data loss goes unnoticed.

### 5. Order Synchronization (Real-time & Bulk)
* **Real-time Method:** `POST /api/v1/orders`
	* **Trigger:** OpenCart event `checkout/order/addOrderHistory/after`.
	* **Payload:** Object containing `externalOrderId`, `externalCustomerId`, `totalCost`, mapped order status, and an `items` array (`externalItemId`, `name`, `cost`, `quantity`).
* **Bulk Method:** `POST /api/v1/orders` (Array Payload)
	* **Trigger:** Background batched execution for historical data, executed periodically via Cron.
	* **Batch Size:** 300 orders per request.
	* **Batch Execution:** The next batch is sent immediately after the previous one completes.
	* **Happy Flow:** Orders are mapped and accepted, triggering the success log.
* **Status Mapping:** Module translates OpenCart statuses (using `config_processing_status` and `config_complete_status`) to Esputnik equivalents for accurate RFM analysis and trigger campaigns.
* **Error Handling:** Validation errors or API unavailability writing to system logs.

### 6. Background Logging System
* The module includes an isolated logging engine specifically for Esputnik API interactions.
* It silently captures all connectivity issues, data validation errors, and file generation faults without exposing them to the frontend user.
* This provides developers with an actionable audit trail for debugging without affecting the store's conversion rates.

---

## 📋 Requirements

* **OpenCart:** 2.3.x or 3.0.x
* **PHP:** 5.6 or higher
* **Extension Installer:** Native OCMOD support enabled
* **Esputnik Account:** Active Esputnik CDP account with generated API credentials

---

## 🛠 Installation Guide

1. Download the latest `esputnik.ocmod.zip` from the Releases page. **Important:** Only download releases directly from this official repository. Beware of pirate platforms and unofficial sources, which routinely deceive users and distribute modified, unsafe archives. Protect your store and customer data by avoiding such sites.
2. Log in to your OpenCart Admin Panel.
3. Navigate to **Extensions > Extension Installer**.
4. Click **Upload** and select the downloaded `esputnik.ocmod.zip` file. Wait for the success message.
5. Go to **Extensions > Modifications** and click the **Refresh** button (top right corner) to rebuild the modifications cache.
6. Navigate to **Extensions > Extensions**, choose **Modules** from the dropdown list.
7. Find **Esputnik CDP Integration** in the list and click the green **Install** button.

---

## 🚀 Configuration & Quick Start

Because of the automated architecture, configuration takes less than a minute:

1. In the Modules list, click **Edit** next to the Esputnik CDP Integration module.
2. Paste your **Esputnik API Key** into the designated field.
3. Click **Synchronize**.

**That’s it!** The module will instantly validate the key. Upon success, Web Tracking and Web Push will be live on your storefront, and the parallel background sync for existing Contacts and Orders will begin automatically.

---

## 🗑 Uninstallation

If you need to remove the module:
1. Go to **Extensions > Extensions > Modules** and click **Uninstall** for Esputnik CDP Integration.
2. Go to **Extensions > Modifications**, select the Esputnik modification, and click **Delete**, then click **Refresh**.

---

## 📄 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE.txt) file for details.