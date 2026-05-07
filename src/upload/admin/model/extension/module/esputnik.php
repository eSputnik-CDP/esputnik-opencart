<?php
class ModelExtensionModuleEsputnik extends Model {
	public function makeRequest($request_data = [], $event_url = '', $method = 'POST', $api_key = '', $override = false) {
		$password = $this->config->get('esputnik_api_key');
		if ((empty($password) || $override) && !empty($api_key)) {
			$password = $api_key;
		}
		if (empty($password)) {
			return;
		}
		$this->load->library('esputnik_http');
		return $this->esputnik_http->requestJson($method, $event_url, $request_data, $password);
	}

	public function makePlainRequest($request_data = [], $event_url = '') {
		$password = $this->config->get('esputnik_api_key');
		if (empty($password)) {
			return;
		}
		$this->load->library('esputnik_http');
		return $this->esputnik_http->requestRaw('GET', $event_url, $request_data, $password);
	}

	public function makeLogRequest($request_data = [], $orgid = '', $event_url = 'https://events.yespo.io/logs/v1/plugin') {
		$request_data['typeCMS'] = 'OpenCart';
		$request_data['errorMessage'] = '';
		$request_data['orgId'] = (int)$this->config->get('esputnik_orgid');
		if (!empty($orgid)) {
			$request_data['orgId'] = (int)$orgid;
		}
		$this->load->library('esputnik_http');
		$this->esputnik_http->requestJson('POST', $event_url, $request_data, '');
	}

	public function getCustomers($start, $limit) {
		$query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "customer` WHERE `status` = '1' ORDER BY `customer_id` ASC LIMIT " . (int)$start . "," . (int)$limit);
		return $query->rows;
	}

	public function getTotalCustomers() {
		$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "customer WHERE status = 1");
		return $query->row['total'];
	}

	public function getOrders($start, $limit) {
		$query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "order` WHERE `order_status_id` > 0 ORDER BY `order_id` ASC LIMIT " . (int)$start . "," . (int)$limit);
		return $query->rows;
	}

	public function getTotalOrders() {
		$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "order WHERE `order_status_id` > 0");
		return $query->row['total'];
	}
}