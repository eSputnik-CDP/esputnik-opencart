<?php
class ControllerExtensionModuleEsputnik extends Controller {
	private $contact_url = 'https://esputnik.com/api/v1/contact';
	private $orders_url = 'https://esputnik.com/api/v1/orders';
	private $token_url = 'https://esputnik.com/api/v1/auth/contact/token';

	public function sendCustomer($customer_id) {
		$this->load->model('account/customer');
		
		$customer_info = $this->model_account_customer->getCustomer($customer_id);
		
		if ($customer_info) {
			$phone = preg_replace('/[^0-9]/', '', (string)$customer_info['telephone']); 
			
			$request_body = [
				'externalCustomerId' => $customer_info['customer_id'],
				'firstName' => $customer_info['firstname'],
				'lastName'  => $customer_info['lastname'],
				'channels'  => [['type' => 'email', 'value' => $customer_info['email']], ['type' => 'sms', 'value' => $phone]],
			];
			
			$this->load->model('extension/module/esputnik');
			
			$this->model_extension_module_esputnik->sendCustomerData();
			
			$response = $this->model_extension_module_esputnik->makeRequest($request_body, $this->contact_url);
			
			if (!empty($response['http_code']) && in_array((int)$response['http_code'], [429, 500])) {
				$this->model_extension_module_esputnik->setBadCustomer($customer_info['customer_id']);
			}
			
			return !empty($response['http_code']) && (int)$response['http_code'] < 400;
		}
	}

	public function addCustomer($route, $args, $output = null) {
		$customer_id = (int)$output;
		
		if ($customer_id) {
			$this->sendCustomer($customer_id);
		}
	}

	public function editCustomer($route, $args, $output = null) {
		$customer_id = 0;
		if (isset($args[0]) && is_scalar($args[0])) {
			$customer_id = (int)$args[0];
		} elseif ($this->customer->isLogged()) {
			$customer_id = $this->customer->getId();
		}
		
		if ($customer_id) {
			$this->sendCustomer($customer_id);
		}
	}
	
	public function processOrder($route, $args, $output = null) {
		$order_id = isset($args[0]) ? (int)$args[0] : 0;
		
		if ($order_id) {
			$this->sendOrder($order_id);
		}
	}

	public function sendOrder($order_id) {
		$this->load->model('checkout/order');
		$this->load->model('catalog/product');
		$this->load->model('tool/image');
		$this->load->model('extension/module/esputnik');
		
		$order_info = $this->model_checkout_order->getOrder($order_id);
		
		if ($order_info) {
			$in_progress_status = $this->config->get('config_processing_status');
			$delivered_status = $this->config->get('config_complete_status');
			
			$items = [];
			
			$product_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "order_product WHERE order_id = '" . (int)$order_id . "'");
			
			if (is_array($product_query->rows)) {
				foreach ($product_query->rows as $product) {
					$product_info = $this->model_catalog_product->getProduct($product['product_id']);
					$image = (!empty($product_info['image'])) ? $product_info['image'] : 'no_image.png';
					
					$items[] = [
						'externalItemId' => $product['product_id'],
						'name'           => $product['name'],
						'quantity'       => (int)$product['quantity'],
						'cost'           => (string)$this->currency->format($product['price'], $this->config->get('config_currency'), '', false),
						'url'            => html_entity_decode($this->url->link('product/product', 'product_id=' . $product['product_id'])),
						'imageUrl'       => $this->model_tool_image->resize($image, 200, 200),
					];
				}
			}
			
			$status = 'INITIALIZED';
			
			if (is_array($in_progress_status) && isset($order_info['order_status_id']) && in_array($order_info['order_status_id'], $in_progress_status)) {
				$status = 'IN_PROGRESS';
			}
			
			if (is_array($delivered_status) && isset($order_info['order_status_id']) && in_array($order_info['order_status_id'], $delivered_status)) {
				$status = 'DELIVERED';
			}
			
			$order_data = [
				'externalOrderId' => $order_info['order_id'],
				'totalCost'       => (string)$this->currency->format($order_info['total'], $this->config->get('config_currency'), '', false),
				'status'          => $status,
				'date'            => gmdate('Y-m-d\TH:i:s\Z', strtotime($order_info['date_added'])),
				'currency'        => (string)$this->config->get('config_currency'),
				'email'           => $order_info['email'],
				'phone'           => preg_replace('/[^0-9]/', '', (string)$order_info['telephone']),
				'firstName'       => $order_info['firstname'],
				'lastName'        => $order_info['lastname'],
				'deliveryMethod'  => isset($order_info['shipping_method']) ? $order_info['shipping_method'] : '',
				'paymentMethod'   => isset($order_info['payment_method']) ? $order_info['payment_method'] : '',
				'items'           => $items,
			];
			
			if (!empty($order_info['customer_id'])) {
				$order_data['externalCustomerId'] = $order_info['customer_id'];
			}
			
			$request_body['orders'] = [$order_data];
			
			$response = $this->model_extension_module_esputnik->makeRequest($request_body, $this->orders_url);
			
			$is_success = !empty($response['http_code']) && (int)$response['http_code'] < 400;
			
			if (!empty($response['http_code']) && in_array((int)$response['http_code'], [429, 500])) {
				$this->model_extension_module_esputnik->setBadOrder($order_info['order_id']);
			}
			
			return $is_success;
		}
		
		return false;
	}
	
	public function checkBadOrdersAndCustomers() {
		$limit = 20;
		$interval = '15 MINUTE';
		
		$query_customers = $this->db->query("SELECT * FROM `" . DB_PREFIX . "esputnik_failed_customers` WHERE `last_attempt` < (NOW() - INTERVAL " . $interval . ") LIMIT " . (int)$limit);
		
		if ($query_customers->num_rows) {
			foreach ($query_customers->rows as $row) {
				$result = $this->sendCustomer((int)$row['customer_id']);
				if ($result === true) {
					$this->db->query("DELETE FROM `" . DB_PREFIX . "esputnik_failed_customers` WHERE customer_id = '" . (int)$row['customer_id'] . "'");
				}
			}
		}
		
		$query_orders = $this->db->query("SELECT * FROM `" . DB_PREFIX . "esputnik_failed_orders` WHERE `last_attempt` < (NOW() - INTERVAL " . $interval . ") LIMIT " . (int)$limit);
		
		if ($query_orders->num_rows) {
			foreach ($query_orders->rows as $row) {
				$result = $this->sendOrder((int)$row['order_id']);
				if ($result === true) {
					$this->db->query("DELETE FROM `" . DB_PREFIX . "esputnik_failed_orders` WHERE order_id = '" . (int)$row['order_id'] . "'");
				}
			}
		}
	}
	
	public function getAppInboxToken() {
		$json = ['token' => ''];
		
		if ($this->customer->isLogged() && $this->request->server['REQUEST_METHOD'] == 'POST') {
			$customer_id = (string)$this->customer->getId();
			$email = $this->customer->getEmail();
			$phone = preg_replace('/[^0-9]/', '', (string)$this->customer->getTelephone());
			
			$this->load->model('extension/module/esputnik');
			
			$request_body = [
				'extid' => $customer_id,
				'email' => $email,
				'phone' => $phone
			];
			
			$response = $this->model_extension_module_esputnik->makeRequest($request_body, $this->token_url);
			
			if (!empty($response['token'])) {
				$json['token'] = $response['token'];
			}
		}
		
		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}
}