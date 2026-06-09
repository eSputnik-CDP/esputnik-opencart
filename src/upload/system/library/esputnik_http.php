<?php
class esputnik_http {
	private $log;
	private $timeout = 5;
	private $connect_timeout = 3;

	public function __construct($registry) {
		$this->log = $registry->has('log') ? $registry->get('log') : null;
	}

	public function requestJson($method, $url, $payload = [], $api_key = '', $headers = []) {
		if (empty($headers)) {
			$headers = [
				'Accept: application/json; charset=UTF-8',
				'Content-Type: application/json; charset=UTF-8'
			];
		}
		
		$response = $this->executeRequest($method, $url, $payload, $api_key, $headers, true);
		
		if ($response['raw_response'] !== '') {
			$decoded = json_decode($response['raw_response'], true);
			
			if (json_last_error() === JSON_ERROR_NONE) {
				$response = array_merge($response, (array)$decoded);
			} else {
				$response['error'] = 'bad_json_format';
				
				if ($response['http_code'] != 200) {
					$this->logError('JSON Decode Error: ' . json_last_error_msg() . ' | URL: ' . $url);
				}
			}
		}
		
		return $response;
	}

	public function requestRaw($method, $url, $payload = [], $api_key = '', $headers = []) {
		if (empty($headers)) {
			$headers = ['Accept: text/plain; charset=UTF-8'];
		}
		
		$response = $this->executeRequest($method, $url, $payload, $api_key, $headers, false);
		$response['text'] = $response['raw_response'];
		
		return $response;
	}

	private function executeRequest($method, $url, $payload, $api_key, $headers, $is_json) {
		$result = [
			'http_code'    => 0,
			'raw_response' => null,
			'error'        => null
		];
		
		if (!extension_loaded('curl')) {
			$result['error'] = 'curl_not_installed';
			$this->logError('Fatal: cURL extension is not loaded!');
			return $result;
		}
		
		$ch = curl_init();
		
		$method = strtoupper(trim($method));
		
		if ($method === 'POST') {
			curl_setopt($ch, CURLOPT_POST, true);
			if (!empty($payload)) {
				curl_setopt($ch, CURLOPT_POSTFIELDS, $is_json ? json_encode($payload) : $payload);
			}
		} elseif ($method === 'PUT') {
			curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PUT');
			if (!empty($payload)) {
				curl_setopt($ch, CURLOPT_POSTFIELDS, $is_json ? json_encode($payload) : http_build_query($payload));
			}
		} elseif ($method === 'DELETE') {
			curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'DELETE');
			if (!empty($payload)) {
				$url .= (strpos($url, '?') === false ? '?' : '&') . http_build_query($payload);
			}
		} else {
			if (!empty($payload)) {
				$url .= (strpos($url, '?') === false ? '?' : '&') . http_build_query($payload);
			}
		}
		
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_HEADER, false);
		curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, $this->connect_timeout);
		curl_setopt($ch, CURLOPT_TIMEOUT, $this->timeout);
		
		if ($api_key !== '') {
			curl_setopt($ch, CURLOPT_USERPWD, 'user:' . $api_key);
		}
		
		$response = curl_exec($ch);
		$curl_error = curl_error($ch);
		$curl_errno = curl_errno($ch);
		$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
		curl_close($ch);
		
		if ($curl_errno) {
			$result['error'] = 'curl_error_' . $curl_errno;
			$this->logError('cURL Error (' . $curl_errno . '): ' . $curl_error . ' | Method: ' . $method . ' | URL: ' . $url);
		}
		
		$result['http_code'] = (int)$http_code;
		$result['raw_response'] = (string)$response;
		
		if ($http_code >= 400 && empty($result['error'])) {
			if ($http_code == 401) {
				$result['error'] = 'unauthorized';
			} elseif ($http_code == 400) {
				$result['error'] = 'bad_request';
			} else {
				$result['error'] = 'http_error_' . $http_code;
			}
		}
		
		return $result;
	}

	private function logError($message) {
		if ($this->log) {
			$this->log->write('Esputnik HTTP API: ' . $message);
		}
	}
}