<?php
class ModelExtensionModuleEsputnik extends Model {
	public function makeLogRequest($request_data = [], $event_url = 'https://events.yespo.io/logs/v1/plugin') {
		$this->load->library('esputnik_http');
		$this->esputnik_http->requestJson('POST', $event_url, $request_data, '');
	}

	public function makeRequest($request_data = [], $event_url = '', $method = 'POST') {
		$password = $this->config->get('esputnik_api_key');
		if (empty($password)) {
			return;
		}
		$this->load->library('esputnik_http');
		return $this->esputnik_http->requestJson($method, $event_url, $request_data, $password);
	}

	public function trackEvent($request_data = []) {
		$this->load->library('esputnik_http');
		$headers = [
			'Accept: application/json; charset=UTF-8',
			'Content-Type: application/json; charset=UTF-8'
		];
		if (isset($this->request->server['HTTP_USER_AGENT'])) {
			$headers[] = 'User-Agent: ' . $this->request->server['HTTP_USER_AGENT'];
		}
		$response = $this->esputnik_http->requestJson('POST', 'https://tracker.yespo.io/api/v2', $request_data, '', $headers);
		$response_json = [
			'text'      => $response['raw_response'],
			'http_code' => $response['http_code']
		];
		
		$log_data = [
			'orgId'        => (int)$this->config->get('esputnik_orgid'),
			'typeCMS'      => 'OpenCart',
			'errorMessage' => '',
			'data'         => json_encode(['domain' => $this->request->server['SERVER_NAME'], 'requestBody' => $request_data, 'responseBody' => $response_json]),
			'message'      => 'TRACK_EVENT',
			'log_level'    => 'INFO',
		];
		
		$this->makeLogRequest($log_data);
		
		return $response_json;
	}
	
	public function setBadOrder($order_id) {
		$this->db->query("DELETE FROM `" . DB_PREFIX . "esputnik_failed_orders` WHERE attempt_count > 5");
		$query = $this->db->query("SELECT id FROM `" . DB_PREFIX . "esputnik_failed_orders` WHERE order_id = '" . (int)$order_id . "' LIMIT 1");
		if ($query->num_rows) {
			$this->db->query("UPDATE `" . DB_PREFIX . "esputnik_failed_orders` SET attempt_count = (attempt_count + 1), last_attempt = NOW() WHERE order_id = '" . (int)$order_id . "'");
		} else {
			$this->db->query("INSERT INTO `" . DB_PREFIX . "esputnik_failed_orders` SET order_id = '" . (int)$order_id . "', attempt_count = 1, last_attempt = NOW()");
		}
	}

	public function setBadCustomer($customer_id) {
		$this->db->query("DELETE FROM `" . DB_PREFIX . "esputnik_failed_customers` WHERE attempt_count > 5");
		$query = $this->db->query("SELECT id FROM `" . DB_PREFIX . "esputnik_failed_customers` WHERE customer_id = '" . (int)$customer_id . "' LIMIT 1");
		if ($query->num_rows) {
			$this->db->query("UPDATE `" . DB_PREFIX . "esputnik_failed_customers` SET attempt_count = (attempt_count + 1), last_attempt = NOW() WHERE customer_id = '" . (int)$customer_id . "'");
		} else {
			$this->db->query("INSERT INTO `" . DB_PREFIX . "esputnik_failed_customers` SET customer_id = '" . (int)$customer_id . "', attempt_count = 1, last_attempt = NOW()");
		}
	}

	public function getGeneralInfo() {
		$general_info = [
			'siteId' => $this->config->get('esputnik_siteid'),
			'datetime' => (int)(microtime(true) * 1000),
		];
		if (!empty($this->request->cookie['sc'])) {
			$general_info['cookies']['sc'] = $this->request->cookie['sc'];
		}
		return $general_info;
	}

	public function getCustomerDataGeneralInfo($order_info = []) {
		if ($this->customer->isLogged()) {
			$general_info = [
				'externalCustomerId' => (int)$this->customer->getId(),
				'user_email'         => $this->customer->getEmail(),
				'user_name'          => $this->customer->getFirstname() . ($this->customer->getLastName() ? ' ' . $this->customer->getLastName() : ''),
				'user_phone'         => preg_replace('/[^0-9]/', '', (string)$this->customer->getTelephone()),
			];
		}
		if ($order_info) {
			$general_info = [
				'user_email' => $order_info['email'],
				'user_name'  => $order_info['firstname'] . ($order_info['lastname'] ? ' ' . $order_info['lastname'] : ''),
				'user_phone' => preg_replace('/[^0-9]/', '', (string)$order_info['telephone']),
			];
			
			if ($order_info['customer_id']) {
				$general_info['externalCustomerId'] = $order_info['customer_id'];
			}
		}
		$general_info['siteId'] = $this->config->get('esputnik_siteid');
		$general_info['datetime'] = (int)(microtime(true) * 1000);
		if (!empty($this->request->cookie['sc'])) {
			$general_info['cookies']['sc'] = $this->request->cookie['sc'];
		}
		return $general_info;
	}

	public function addWishlist($product_info) {
		$tracking_data = [];
		$tracking_data['GeneralInfo']['eventName'] = 'AddToWishlist';
		$general_info = $this->getGeneralInfo();
		if (!empty($general_info)) {
			$tracking_data['GeneralInfo'] = array_merge($tracking_data['GeneralInfo'], $general_info);
		}
		$tracking_data['AddToWishlist'] = [];
		$tracking_data['AddToWishlist']['Product'] = [
			'productKey' => (string)$product_info['product_id'],
			'price'      => (string)$this->currency->format($product_info['special'] ? $product_info['special'] : $product_info['price'], $this->session->data['currency'], '', false),
			'isInStock'  => (string)($product_info['quantity'] > 0),
		];
 		$this->trackEvent($tracking_data);
	}

	public function sendCustomerData($order_info = []) {
		$tracking_data = [];
		$tracking_data['GeneralInfo']['eventName'] = 'CustomerData';
		$general_info = $this->getCustomerDataGeneralInfo($order_info);
		if (!empty($general_info)) {
			$tracking_data['GeneralInfo'] = array_merge($tracking_data['GeneralInfo'], $general_info);
		}
		$this->trackEvent($tracking_data);
		usleep(200000);
	}

	public function sendCart() {
		$this->session->data['esputnik_guid'] = uniqid();
		$tracking_data = [];
		$tracking_data['GeneralInfo']['eventName'] = 'StatusCart';
		$general_info = $this->getGeneralInfo();
		if (!empty($general_info)) {
			$tracking_data['GeneralInfo'] = array_merge($tracking_data['GeneralInfo'], $general_info);
		}
		$tracking_data['StatusCart'] = [];
		if (!empty($this->session->data['esputnik_guid'])) {
			$tracking_data['StatusCart']['GUID'] = $this->session->data['esputnik_guid'];
		}
		$tracking_data['StatusCart']['Products'] = [];
		$products = $this->cart->getProducts();
		foreach ($products as $product) {
			$cart_product = [
				'productKey' => (string)$product['product_id'],
				'price'      => (string)$this->currency->format($product['price'], $this->session->data['currency'], '', false),
				'quantity'   => (int)$product['quantity'],
				'price_currency_code' => $this->session->data['currency'],
			];
			$tracking_data['StatusCart']['Products'][] = $cart_product;
		}
		$this->trackEvent($tracking_data);
	}

	public function sendOrder($order_id, $order_info) {
		$this->sendCustomerData($order_info);
		$tracking_data = [];
		$tracking_data['GeneralInfo'] = [
			'eventName' => 'PurchasedItems',
			'siteId'    => $this->config->get('esputnik_siteid'),
			'datetime'  => (int)(microtime(true) * 1000),
		];
		$general_info = $this->getGeneralInfo();
		if (!empty($this->request->cookie['sc'])) {
			$general_info['cookies']['sc'] = $this->request->cookie['sc'];
		}
		if (!empty($general_info)) {
			$tracking_data['GeneralInfo'] = array_merge($tracking_data['GeneralInfo'], $general_info);
		}
		$tracking_data['PurchasedItems'] = [];
		$tracking_data['PurchasedItems']['OrderNumber'] = (string)$order_id;
		if (!empty($this->session->data['esputnik_guid'])) {
			$tracking_data['PurchasedItems']['GUID'] = $this->session->data['esputnik_guid'];
		}
		$tracking_data['PurchasedItems']['TrackedOrderId'] = uniqid();
		$tracking_data['PurchasedItems']['Products'] = [];
		$order_product_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "order_product WHERE order_id = '" . (int)$order_id . "'");
		foreach ($order_product_query->rows as $product) {
			$tracking_data['PurchasedItems']['Products'][] = [
				'product_id' => (string)$product['product_id'],
				'unit_price' => (string)$this->currency->format($product['price'], $this->config->get('config_currency'), '', false),
				'quantity'   => (int)$product['quantity'],
			];
		}
		$this->trackEvent($tracking_data);
	}
}