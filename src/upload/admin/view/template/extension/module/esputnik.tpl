<?php echo $header; ?><?php echo $column_left; ?>
<div id="content">
	<div class="page-header">
		<div class="container-fluid">
			<div class="pull-right">
				<a href="<?php echo $cancel; ?>" data-toggle="tooltip" title="<?php echo $button_cancel; ?>" class="btn btn-default"><i class="fa fa-reply"></i></a>
			</div>
			<h1><?php echo $heading_title; ?></h1>
			<ul class="breadcrumb">
				<?php foreach ($breadcrumbs as $breadcrumb) { ?>
				<li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
				<?php } ?>
			</ul>
		</div>
	</div>
	<div class="container-fluid">
		<?php if ($error_warning) { ?>
		<div class="alert alert-danger alert-dismissible"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
			<button type="button" class="close" data-dismiss="alert">&times;</button>
		</div>
		<?php } ?>
		
		<div class="panel panel-default" style="border:none; box-shadow:none; background:transparent;">
			<div class="panel-heading top-panel-heading" id="original-logo-header">
				<svg width="155" height="41" viewBox="0 0 155 41" fill="none" xmlns="http://www.w3.org/2000/svg">
				<g clip-path="url(#clip0_1368_77)">
				<path d="M61.777 21.859C61.777 21.905 61.754 22.227 61.708 22.825H52.347C52.5157 23.5917 52.9143 24.1973 53.543 24.642C54.1717 25.0867 54.9537 25.309 55.889 25.309C56.533 25.309 57.1003 25.217 57.591 25.033C58.097 24.8337 58.5647 24.527 58.994 24.113L60.903 26.183C59.7377 27.517 58.0357 28.184 55.797 28.184C54.4017 28.184 53.1673 27.9157 52.094 27.379C51.0207 26.827 50.1927 26.068 49.61 25.102C49.0273 24.136 48.736 23.0397 48.736 21.813C48.736 20.6017 49.0197 19.513 49.587 18.547C50.1697 17.5657 50.9593 16.8067 51.956 16.27C52.968 15.718 54.095 15.442 55.337 15.442C56.5483 15.442 57.6447 15.7027 58.626 16.224C59.6073 16.7453 60.374 17.4967 60.926 18.478C61.4933 19.444 61.777 20.571 61.777 21.859ZM55.36 18.156C54.5473 18.156 53.865 18.386 53.313 18.846C52.761 19.306 52.4237 19.9347 52.301 20.732H58.396C58.2733 19.95 57.936 19.329 57.384 18.869C56.832 18.3937 56.1573 18.156 55.36 18.156ZM69.4788 28.276C68.2061 28.276 66.9718 28.1073 65.7758 27.77C64.5951 27.4173 63.6444 26.965 62.9238 26.413L64.1888 23.607C64.8788 24.113 65.6991 24.5193 66.6498 24.826C67.6004 25.1327 68.5511 25.286 69.5018 25.286C70.5598 25.286 71.3418 25.1327 71.8478 24.826C72.3538 24.504 72.6068 24.0823 72.6068 23.561C72.6068 23.1777 72.4534 22.8633 72.1468 22.618C71.8554 22.3573 71.4721 22.1503 70.9968 21.997C70.5368 21.8437 69.9081 21.675 69.1108 21.491C67.8841 21.1997 66.8798 20.9083 66.0978 20.617C65.3158 20.3257 64.6411 19.858 64.0738 19.214C63.5218 18.57 63.2458 17.7113 63.2458 16.638C63.2458 15.7027 63.4988 14.8593 64.0048 14.108C64.5108 13.3413 65.2698 12.7357 66.2818 12.291C67.3091 11.8463 68.5588 11.624 70.0308 11.624C71.0581 11.624 72.0624 11.7467 73.0438 11.992C74.0251 12.2373 74.8838 12.59 75.6198 13.05L74.4698 15.879C72.9824 15.0357 71.4951 14.614 70.0078 14.614C68.9651 14.614 68.1908 14.7827 67.6848 15.12C67.1941 15.4573 66.9488 15.902 66.9488 16.454C66.9488 17.006 67.2324 17.42 67.7998 17.696C68.3824 17.9567 69.2641 18.2173 70.4448 18.478C71.6714 18.7693 72.6758 19.0607 73.4578 19.352C74.2398 19.6433 74.9068 20.1033 75.4588 20.732C76.0261 21.3607 76.3098 22.2117 76.3098 23.285C76.3098 24.205 76.0491 25.0483 75.5278 25.815C75.0218 26.5663 74.2551 27.1643 73.2278 27.609C72.2004 28.0537 70.9508 28.276 69.4788 28.276ZM85.6868 15.442C86.8368 15.442 87.8794 15.7103 88.8148 16.247C89.7654 16.7683 90.5091 17.512 91.0458 18.478C91.5824 19.4287 91.8508 20.5403 91.8508 21.813C91.8508 23.0857 91.5824 24.205 91.0458 25.171C90.5091 26.1217 89.7654 26.8653 88.8148 27.402C87.8794 27.9233 86.8368 28.184 85.6868 28.184C84.1074 28.184 82.8654 27.6857 81.9608 26.689V32.462H78.3728V15.626H81.7998V17.052C82.6891 15.9787 83.9848 15.442 85.6868 15.442ZM85.0658 25.24C85.9858 25.24 86.7371 24.9333 87.3198 24.32C87.9178 23.6913 88.2168 22.8557 88.2168 21.813C88.2168 20.7703 87.9178 19.9423 87.3198 19.329C86.7371 18.7003 85.9858 18.386 85.0658 18.386C84.1458 18.386 83.3868 18.7003 82.7888 19.329C82.2061 19.9423 81.9148 20.7703 81.9148 21.813C81.9148 22.8557 82.2061 23.6913 82.7888 24.32C83.3868 24.9333 84.1458 25.24 85.0658 25.24ZM106.489 15.626V28H103.085V26.528C102.609 27.0647 102.042 27.4787 101.383 27.77C100.723 28.046 100.01 28.184 99.2436 28.184C97.6183 28.184 96.3303 27.7163 95.3796 26.781C94.429 25.8457 93.9536 24.458 93.9536 22.618V15.626H97.5416V22.089C97.5416 24.0823 98.3773 25.079 100.049 25.079C100.907 25.079 101.597 24.803 102.119 24.251C102.64 23.6837 102.901 22.848 102.901 21.744V15.626H106.489ZM117.564 27.402C117.211 27.6627 116.774 27.862 116.253 28C115.747 28.1227 115.21 28.184 114.643 28.184C113.171 28.184 112.028 27.8083 111.216 27.057C110.418 26.3057 110.02 25.2017 110.02 23.745V18.662H108.111V15.902H110.02V12.889H113.608V15.902H116.69V18.662H113.608V23.699C113.608 24.2203 113.738 24.6267 113.999 24.918C114.275 25.194 114.658 25.332 115.149 25.332C115.716 25.332 116.199 25.1787 116.598 24.872L117.564 27.402ZM126.869 15.442C128.402 15.442 129.636 15.902 130.572 16.822C131.522 17.742 131.998 19.1067 131.998 20.916V28H128.41V21.468C128.41 20.4867 128.195 19.7583 127.766 19.283C127.336 18.7923 126.715 18.547 125.903 18.547C124.998 18.547 124.277 18.8307 123.741 19.398C123.204 19.95 122.936 20.778 122.936 21.882V28H119.348V15.626H122.775V17.075C123.25 16.5537 123.84 16.155 124.546 15.879C125.251 15.5877 126.025 15.442 126.869 15.442ZM135.02 15.626H138.608V28H135.02V15.626ZM136.814 13.901C136.155 13.901 135.618 13.7093 135.204 13.326C134.79 12.9427 134.583 12.4673 134.583 11.9C134.583 11.3327 134.79 10.8573 135.204 10.474C135.618 10.0907 136.155 9.89905 136.814 9.89905C137.473 9.89905 138.01 10.083 138.424 10.451C138.838 10.819 139.045 11.279 139.045 11.831C139.045 12.429 138.838 12.9273 138.424 13.326C138.01 13.7093 137.473 13.901 136.814 13.901ZM147.021 23.147L145.296 24.849V28H141.708V10.934H145.296V20.594L150.54 15.626H154.818L149.666 20.87L155.278 28H150.931L147.021 23.147Z" fill="#2B64CD"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M41 20.5C41 9.17944 31.8213 0 20.5 0C9.17867 0 0 9.17944 0 20.5C0 22.7771 0.371357 24.9675 1.05681 27.014L8.85711 24.0352C8.55872 22.9418 8.40132 21.7929 8.40132 20.6081C8.40132 18.1439 9.08336 15.8363 10.2704 13.8649L0.485879 16.0435C0.882638 14.4213 1.37596 12.8239 2.13669 11.378L18.7597 7.76135L18.7498 7.76788C19.6778 7.56225 20.6418 7.45455 21.6288 7.45455C28.236 7.45455 33.7119 12.2819 34.6923 18.5812L33.5053 19.0349L33.0659 19.2014L30.7116 20.0989L19.6942 24.3094L19.6876 24.3029C19.4384 24.4073 19.163 24.4661 18.8744 24.4661C17.7268 24.4661 16.7988 23.5424 16.7988 22.4033C16.7988 21.4665 17.4284 20.6734 18.2908 20.4221L29.5312 16.13C27.9638 13.3981 25.0062 11.554 21.6157 11.554C16.5857 11.554 12.5099 15.6078 12.5099 20.6114C12.5099 25.6117 16.5857 29.6687 21.6157 29.6687C25.5833 29.6687 28.9607 27.1425 30.2067 23.6207C30.3772 22.6513 31.2264 21.9169 32.2495 21.9169C33.3971 21.9169 34.3251 22.8406 34.3251 23.9797C34.3251 24.2702 34.2628 24.5476 34.1545 24.799C33.0922 27.9421 30.8658 30.5565 27.9835 32.133L14.6929 40.1657C16.5341 40.7086 18.483 41 20.5 41C31.8213 41 41 31.8206 41 20.5ZM10.0536 38.142L18.094 33.2819C14.9626 32.4202 12.2968 30.439 10.5589 27.8018L2.76139 30.7818C4.52284 33.8139 7.03944 36.3532 10.0536 38.142Z" fill="#2B64CD"/>
				</g>
				<defs>
				<clipPath id="clip0_1368_77">
				<rect width="155" height="41" fill="white"/>
				</clipPath>
				</defs>
				</svg>
			</div>
			<div class="panel-body" id="sync-form-container" <?php if ($esputnik_api_key) { ?>style="display:none;"<?php } ?>>
				<form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form-esputnik" class="form-horizontal">
					<div class="sync-card custom-sync-form" style="background:#fff; border:1px solid #ddd;">
						<div class="api-form">
							<h2><?php echo $text_data_sync; ?></h2>
							<p class="text-heading"><?php echo $text_in_head; ?></p>
							<div class="form-group" style="margin:0;">
								<label class="control-label" for="input-api-key"><?php echo $entry_api_key; ?></label>
								<input type="text" name="temp_api_key" id="input-api-key" class="form-control custom-input" value="<?php echo $esputnik_api_key; ?>" />
								<div class="help-text">
									<?php echo $text_key_help; ?>
								</div>
								<div id="initial-error-log"></div>
							</div>
							<div class="form-group" style="margin:0;">
								<button type="button" id="button-sync" class="btn btn-primary btn-lg custom-btn">
									<?php echo $button_sync; ?>
								</button>
							</div>
						</div>
					</div>
				</form>
			</div>

			<div class="esputnik-steps-container" id="integration-steps" <?php if (!$esputnik_api_key) { ?>style="display:none;"<?php } ?>>
				
				<div class="step-card" id="step-account">
					<div class="step-icon">
						<div class="status-default" style="display:none;"></div>
						<img src="view/image/esputnik/esputnik-loading.png" class="status-loading status-icon esputnik-spin" style="display:none;" alt="loading">
						<img src="view/image/esputnik/esputnik-success.png" class="status-success status-icon" style="display:none;" alt="success">
						<img src="view/image/esputnik/esputnik-error.png" class="status-error status-icon" style="display:none;" alt="error">
					</div>
					<div class="step-content">
						<h4 class="step-title"><?php echo $text_account_connection; ?></h4>
						<p class="text-muted status-success-msg" style="margin:0; display:none;"><?php echo $text_api_key_connected; ?> <strong><span id="org-name"><?php echo $esputnik_orgname; ?></span></strong></p>
						
						<div class="status-error-msg" style="display:none;">
							<p class="text-muted" style="color: #666; margin: 0;"><?php echo $error_api_key; ?></p>
						</div>
					</div>
					<div class="step-action">
						<a href="<?php echo $disconnect; ?>" class="btn btn-default btn-disconnect" style="display:none;" onclick="return confirm('<?php echo $text_you_sure; ?>');"><?php echo $text_disconnect; ?></a>
						<a href="<?php echo $disconnect; ?>" class="btn btn-primary btn-try-again" style="display:none;"><?php echo $text_try_again; ?></a>
					</div>
				</div>

				<div class="step-card" id="step-tracking" style="display:none;">
					<div class="step-icon">
						<div class="status-default"></div>
						<img src="view/image/esputnik/esputnik-loading.png" class="status-loading status-icon esputnik-spin" style="display:none;" alt="loading">
						<img src="view/image/esputnik/esputnik-success.png" class="status-success status-icon" style="display:none;" alt="success">
						<img src="view/image/esputnik/esputnik-error.png" class="status-error status-icon" style="display:none;" alt="error">
					</div>
					<div class="step-content">
						<h4 class="step-title"><?php echo $text_web_tracking; ?></h4>
						<p class="text-muted success-msg" style="display:none; margin:0;"><?php echo $text_site_script_installed; ?></p>
						<p class="text-muted error-msg" style="display:none; margin:0;"><?php echo $error_site_script; ?></p>
					</div>
					<div class="step-action">
						 <div class="error-actions" style="display:none; display:flex; gap:10px;">
							<a href="https://esputnik.io/contact-us" target="_blank" class="btn btn-default btn-support"><?php echo $button_support; ?></a>
							<button type="button" class="btn btn-primary btn-retry-step btn-tryagain"><?php echo $text_try_again; ?></button>
						 </div>
					</div>
				</div>

				<div class="step-card" id="step-push" style="display:none;">
					<div class="step-icon">
						<div class="status-default"></div>
						<img src="view/image/esputnik/esputnik-loading.png" class="status-loading status-icon esputnik-spin" style="display:none;" alt="loading">
						<img src="view/image/esputnik/esputnik-success.png" class="status-success status-icon" style="display:none;" alt="success">
						<img src="view/image/esputnik/esputnik-error.png" class="status-error status-icon" style="display:none;" alt="error">
					</div>
					<div class="step-content">
						<h4 class="step-title"><?php echo $text_web_push; ?></h4>
						<p class="text-muted success-msg" style="display:none; margin:0;"><?php echo $text_web_push_success; ?></p>
						<p class="text-muted error-msg" style="display:none; margin:0;"><?php echo $error_web_push; ?></p>
					</div>
					<div class="step-action">
						 <div class="error-actions" style="display:none; display:flex; gap:10px;">
							<a href="https://esputnik.com/contact-us" target="_blank" class="btn btn-default btn-support"><?php echo $button_support; ?></a>
							<button type="button" class="btn btn-primary btn-retry-step btn-tryagain"><?php echo $text_try_again; ?></button>
						 </div>
					</div>
				</div>

				<div class="step-card" id="step-import" style="display:none;">
					<div class="step-icon">
						<div class="status-default"></div>
						<img src="view/image/esputnik/esputnik-loading.png" class="status-loading status-icon esputnik-spin" style="display:none;" alt="loading">
						<img src="view/image/esputnik/esputnik-success.png" class="status-success status-icon" style="display:none;" alt="success">
						<img src="view/image/esputnik/esputnik-error.png" class="status-error status-icon" style="display:none;" alt="error">
					</div>
					<div class="step-content" style="flex-grow: 1; padding-right: 15px;">
						<h4 class="step-title"><?php echo $text_import_history; ?></h4>
						
						<div class="import-wrapper">
							<p class="text-muted import-desc status-loading-msg" style="display:none; margin:0;"><?php echo $text_first_export; ?></p>
							<p class="text-muted import-desc status-success-msg" style="display:none; margin:0;"><?php echo $text_import_success; ?></p>
							<p class="text-danger import-error-msg" style="display:none; margin-top:5px; line-height: 1.4;"></p>
							
							<div class="import-stats-table">
								<div class="stat-row header">
									<div class="col-name"></div>
									<div class="col-val"><?php echo $text_loading_total; ?></div>
									<div class="col-val"><?php echo $text_loading_synchronized; ?></div>
									<div class="col-val"><?php echo $text_loading_success; ?></div>
									<div class="col-val"><?php echo $text_loading_failed; ?></div>
								</div>
								<div class="stat-row">
									<div class="col-name" style="display: flex; align-items: center; gap: 10px;">
										<div id="icon-customers-status" style="width:16px; height:16px;">
											<div class="status-default-sm"></div>
											<img src="view/image/esputnik/esputnik-loading.png" class="status-loading status-icon-sm esputnik-spin" style="display:none;" alt="loading">
											<img src="view/image/esputnik/esputnik-success.png" class="status-success status-icon-sm" style="display:none;" alt="success">
											<img src="view/image/esputnik/esputnik-error.png" class="status-error status-icon-sm" style="display:none;" alt="error">
										</div>
										<?php echo $text_contacts; ?>
									</div>
									<div class="col-val" id="val-customers-total">-</div>
									<div class="col-val" id="val-customers-synced">-</div>
									<div class="col-val text-success" id="val-customers-success">-</div>
									<div class="col-val text-danger" id="val-customers-failed">-</div>
								</div>
								<div class="stat-row">
									<div class="col-name" style="display: flex; align-items: center; gap: 10px;">
										<div id="icon-orders-status" style="width:16px; height:16px;">
											<div class="status-default-sm"></div>
											<img src="view/image/esputnik/esputnik-loading.png" class="status-loading status-icon-sm esputnik-spin" style="display:none;" alt="loading">
											<img src="view/image/esputnik/esputnik-success.png" class="status-success status-icon-sm" style="display:none;" alt="success">
											<img src="view/image/esputnik/esputnik-error.png" class="status-error status-icon-sm" style="display:none;" alt="error">
										</div>
										 <?php echo $text_orders; ?>
									</div>
									<div class="col-val" id="val-orders-total">-</div>
									<div class="col-val" id="val-orders-synced">-</div>
									<div class="col-val text-success" id="val-orders-success">-</div>
									<div class="col-val text-danger" id="val-orders-failed">-</div>
								</div>
							</div>
						</div>
					</div>
					<div class="step-action">
						 <div class="error-actions" style="display:none; display:flex; gap:10px;">
							<button type="button" class="btn btn-primary btn-retry-import btn-tryagain"><?php echo $text_try_again; ?></button>
						 </div>
					</div>
				</div>

			</div>
			<div class="panel panel-default" id="app-inbox-container" style="display:none;">
				<div class="panel-body">
					<div>
						<h4 class="step-title" style="display: flex; align-items: center;">
							<?php echo $text_app_inbox; ?>
							<span id="badge-app-inbox" class="badge-status <?php if ($esputnik_app_inbox == '1') { ?>enabled<?php } else { ?>disabled<?php } ?>">
								<?php if ($esputnik_app_inbox == '1') { ?><?php echo $text_enabled; ?><?php } else { ?><?php echo $text_disabled; ?><?php } ?>
							</span>
						</h4>
						<p class="text-muted"><?php echo $text_app_inbox_more; ?></p>
					</div>
					<div>
						<button type="button" id="btn-app-inbox" class="btn btn-default" data-status="<?php echo $esputnik_app_inbox; ?>">
							<?php if ($esputnik_app_inbox == '1') { ?><?php echo $button_disable; ?><?php } else { ?><?php echo $button_enable; ?><?php } ?>
						</button>
					</div>
				</div>
			</div>
			<div class="made text-right" style="margin-top: 20px;"><?php echo $text_made; ?></div>
		</div>
	</div>
</div>

<style>
.custom-sync-form { padding: 20px; font-family: Arial, sans-serif; }
.custom-input { border: none; border-bottom: 2px solid #1e91cf; box-shadow: none; border-radius: 0; padding-left: 0; padding-right: 0; height: 40px; background: transparent; width: 100%; font-size: 17px; max-width: 600px; }
.custom-input:hover, .custom-input:focus { border-bottom: 2px solid #1e91cf; box-shadow: none; outline: none; }
.custom-sync-form .form-control:hover, .custom-sync-form .form-control:focus { border-top: 0; border-left: 0; border-right: 0; box-shadow: none; }
.help-text { margin-top: 10px; color: #999; font-size: 15px; padding-top: 15px; max-width: 600px; }
.custom-btn { margin-top: 20px; background-color: #1a64a7; border-color: #1a64a7; border-radius: 4px; padding: 10px 30px; font-size: 16px; color: #fff; }
.custom-btn:hover { background-color: #145086; color: #fff; }

.status-icon { width: 24px; height: 24px; display: inline-block; vertical-align: middle; }
.status-error.status-icon { width: 36px; height: 36px; margin-top: -6px; }
.status-default { width: 24px; height: 24px; border-radius: 50%; border: 2px solid #ccc; display: inline-block; box-sizing: border-box; }
.status-icon-sm { width: 16px; height: 16px; display: inline-block; vertical-align: middle; }
.status-default-sm { width: 16px; height: 16px; border-radius: 50%; border: 2px solid #ccc; display: inline-block; box-sizing: border-box; }

.esputnik-spin { animation: esputnik-spin-anim 1.5s linear infinite; }
@keyframes esputnik-spin-anim { 100% { transform: rotate(360deg); } }

.esputnik-steps-container { background: #fff; border: 1px solid #ddd; border-radius: 3px; padding: 0; }
.step-card { display: flex; align-items: flex-start; padding: 20px; border-bottom: 1px solid #e1e1e1; }
.step-card:last-child { border-bottom: none; }
.step-icon { width: 40px; margin-right: 15px; text-align: center; padding-top: 2px; }
.step-content { flex-grow: 1; }
.step-action { min-width: 150px; text-align: right; display: flex; justify-content: flex-end; align-items: flex-start; gap: 10px; }
.step-title { margin: 0 0 5px 0; font-size: 16px; font-weight: 500; color: #333; }
.text-muted { color: #777; font-size: 14px; }

.btn.btn-disconnect, .btn.btn-support, .btn.btn-tryagain, .btn.btn-try-again { padding: 8px 15px; border-radius: 4px; font-size: 16px; box-shadow: 0px 0px 2px 0px rgba(0, 0, 0, 0.25), 0px 2px 4px 0px rgba(0, 0, 0, 0.12); }
.btn.btn-tryagain, .btn.btn-try-again { background: #2b64cd; color: #fff; border-color: #2b64cd; }
.btn.btn-tryagain:hover, .btn.btn-try-again:hover { background: #1a4b9e; color: #fff; border-color: #1a4b9e; }

.import-stats-table { margin-top: 15px; width: 100%; max-width: 800px; }
.stat-row { display: flex; padding: 10px 0; border-bottom: 1px solid #e1e1e1; align-items: center; }
.stat-row.header { color: #999; font-size: 12px; text-transform: uppercase; border-bottom: 1px solid #eee; }
.stat-row .col-name { width: 150px; font-weight: 500; }
.stat-row .col-val { width: 120px; text-align: left; }
#app-inbox-container { margin-top: 20px; border-radius: 3px; border: 1px solid #ddd; box-shadow: none; background: #fff; }
#app-inbox-container .panel-body { display: flex; justify-content: left; align-items: center; padding: 20px; margin-left: 50px; margin-right: 20px; }
#app-inbox-container button { padding: 8px 15px; border-radius: 4px; font-size: 16px; box-shadow: 0px 0px 2px 0px rgba(0, 0, 0, 0.25), 0px 2px 4px 0px rgba(0, 0, 0, 0.12); margin-left: 15px; }
.badge-status { padding: 6px 8px; border-radius: 4px; font-size: 14px; font-weight: 500; margin-left: 10px; line-height: 1; }
.badge-status.enabled { background-color: #abffc3; color: #0f5132; }
.badge-status.disabled { background-color: #ffc7d1; color: #842029; }
</style>

<script type="text/javascript">
var hasApiKey = <?php echo $esputnik_api_key ? 'true' : 'false'; ?>;
var isModuleActive = <?php echo $esputnik_status == '1' ? 'true' : 'false'; ?>;
var hasSiteScript = <?php echo $esputnik_site_script ? 'true' : 'false'; ?>;
var hasWebPush = <?php echo $esputnik_web_push ? 'true' : 'false'; ?>;

var custLoaded = ('<?php echo $esputnik_customers_loaded; ?>' === '1');
var ordersLoaded = ('<?php echo $esputnik_orders_loaded; ?>' === '1');

var rawCustPage = '<?php echo $esputnik_customers_page; ?>'.replace(/\D/g, '');
var custPage = parseInt(rawCustPage, 10) || 1;

var rawCustLimit = '<?php echo $customers_limit; ?>'.replace(/\D/g, '');
var custLimit = parseInt(rawCustLimit, 10) || 2000;

var rawOrdersPage = '<?php echo $esputnik_orders_page; ?>'.replace(/\D/g, '');
var ordersPage = parseInt(rawOrdersPage, 10) || 1;

var rawOrdersLimit = '<?php echo $orders_limit; ?>'.replace(/\D/g, '');
var ordersLimit = parseInt(rawOrdersLimit, 10) || 300;

var customersStats = { 
	total: parseInt('<?php echo $total_customers_db; ?>'.replace(/\D/g, ''), 10) || 0, 
	synced: 0, 
	success: 0, 
	failed: parseInt('<?php echo $esputnik_bad_customers; ?>'.replace(/\D/g, ''), 10) || 0 
};
var ordersStats = { 
	total: parseInt('<?php echo $total_orders_db; ?>'.replace(/\D/g, ''), 10) || 0, 
	synced: 0, 
	success: 0, 
	failed: parseInt('<?php echo $esputnik_bad_orders; ?>'.replace(/\D/g, ''), 10) || 0 
};

var isCustomersDone = false;
var isOrdersDone = false;

var maxRetries = 5;
var custRetries = 0;
var ordersRetries = 0;

var custFailed = false;
var ordersFailed = false;

$(document).ready(function() {
	if (hasApiKey) {
		verifyApiKeyOnLoad();
	}
});

function verifyApiKeyOnLoad() {
	var apiKey = $('#input-api-key').val();
	setStepStatus('step-account', 'loading');
	
	$.ajax({
		url: '<?php echo $check_api_key; ?>',
		type: 'post',
		data: { api_key: apiKey },
		dataType: 'json',
		success: function(json) {
			if (json['success']) {
				setStepStatus('step-account', 'success');
				
				if (custLoaded) {
					isCustomersDone = true;
					customersStats.synced = customersStats.total;
					customersStats.success = Math.max(0, customersStats.total - customersStats.failed);
				} else {
					customersStats.synced = (custPage > 1) ? (custPage - 1) * custLimit : 0;
					customersStats.success = Math.max(0, customersStats.synced - customersStats.failed);
				}

				if (ordersLoaded) {
					isOrdersDone = true;
					ordersStats.synced = ordersStats.total;
					ordersStats.success = Math.max(0, ordersStats.total - ordersStats.failed);
				} else {
					ordersStats.synced = (ordersPage > 1) ? (ordersPage - 1) * ordersLimit : 0;
					ordersStats.success = Math.max(0, ordersStats.synced - ordersStats.failed);
				}

				startProcesses();
			} else {
				setStepStatus('step-account', 'error');
			}
		},
		error: function() {
			setStepStatus('step-account', 'error');
		}
	});
}

function showInitialError(msg) {
	var errHtml = '<div style="display:flex; align-items:flex-start; margin-top:20px;">' + 
				  '<div style="width:40px; margin-right:15px; text-align:center; padding-top:2px;">' +
				  '<img src="view/image/esputnik/esputnik-error.png" class="status-icon" alt="error">' +
				  '</div>' +
				  '<div style="flex-grow:1; display:flex; align-items:center; min-height: 24px;"><p class="text-muted" style="color:#666; margin:0;">' + msg + '</p></div>' +
				  '</div>';
	$('#initial-error-log').html(errHtml);
}

$('#button-sync').on('click', function() {
	var apiKey = $('#input-api-key').val();
	var $btn = $(this);
	
	$('#initial-error-log').empty();

	if (!apiKey) {
		showInitialError('<?php echo $error_api_key_required; ?>');
		return;
	}
	
	$btn.button('loading');
	
	$.ajax({
		url: '<?php echo $check_api_key; ?>',
		type: 'post',
		data: { api_key: apiKey },
		dataType: 'json',
		success: function(json) {
			if (json['success']) {
				$('#sync-form-container').slideUp();
				$('#org-name').text(json['org_name']);
				$('#integration-steps').slideDown();
				
				if (json['reset']) {
					hasApiKey = true;
					isModuleActive = false;
					custPage = 1;
					ordersPage = 1;
					customersStats.synced = 0;
					ordersStats.synced = 0;
					customersStats.failed = 0;
					ordersStats.failed = 0;
					customersStats.success = 0;
					ordersStats.success = 0;
					custLoaded = false;
					ordersLoaded = false;
					hasSiteScript = false;
					hasWebPush = false;
					isCustomersDone = false;
					isOrdersDone = false;
				}
				
				setStepStatus('step-account', 'success');
				startProcesses(); 
			} else {
				$btn.button('reset');
				showInitialError('<?php echo $error_api_key; ?>');
			}
		},
		error: function() {
			$btn.button('reset');
			showInitialError('<?php echo $error_connection; ?>');
		}
	});
});

function startProcesses() {
	$('#step-tracking').slideDown(0);
	$('#step-push').slideDown(0);
	$('#step-import').slideDown(0);

	if (!hasSiteScript) {
		getSiteScript(1);
	} else {
		setStepStatus('step-tracking', 'success');
		$('#app-inbox-container').slideDown();
	}

	if (!hasWebPush) {
		addWebPush(1);
	} else {
		setStepStatus('step-push', 'success');
	}

	startImports();
}

function setStepStatus(stepId, status) {
	var $step = $('#' + stepId);
	$step.find('.step-icon').children().hide();
	
	if (status == 'default') {
		$step.find('.status-default').show();
	} else if (status == 'loading') {
		$step.find('.status-loading').show();
		
		if (stepId == 'step-tracking' || stepId == 'step-push') {
			$step.find('.error-msg').hide();
			$step.find('.error-actions').hide();
		}
		if (stepId == 'step-account') {
			$step.find('.status-error-msg').hide();
			$step.find('.btn-try-again').hide();
		}
		if (stepId == 'step-import') {
			$step.find('.error-actions').hide();
		}
		
	} else if (status == 'success') {
		$step.find('.status-success').show();
		
		if (stepId == 'step-account') {
			$step.find('.status-success-msg').show();
			$step.find('.status-error-msg').hide();
			$step.find('.btn-disconnect').show();
			$step.find('.btn-try-again').hide();
		}
		if (stepId == 'step-import') {
			$('.status-loading-msg').hide();
			$('.import-error-msg').hide();
			$('.status-success-msg').show();
			$step.find('.error-actions').hide();
		}
		if (stepId == 'step-tracking' || stepId == 'step-push') {
			$step.find('.success-msg').show();
			$step.find('.error-msg').hide();
			$step.find('.error-actions').hide();
		}
	} else if (status == 'error') {
		$step.find('.status-error').show();
		
		if (stepId == 'step-account') {
			$step.find('.status-success-msg').hide();
			$step.find('.status-error-msg').show();
			$step.find('.btn-disconnect').hide();
			$step.find('.btn-try-again').show();
		}
		if (stepId == 'step-tracking' || stepId == 'step-push') {
			$step.find('.success-msg').hide();
			$step.find('.error-msg').show();
			$step.find('.error-actions').css('display', 'flex'); 
		}
		if (stepId == 'step-import') {
			$step.find('.status-loading-msg').hide();
			$step.find('.status-success-msg').hide();
			$step.find('.error-actions').css('display', 'flex'); 
		}
	}
}

function updateImportUI(type, status) {
	var $container = $('#icon-' + type + '-status');
	$container.children().hide();
	
	if (status == 'loading') {
		$container.find('.status-loading').show();
	} else if (status == 'success') {
		$container.find('.status-success').show();
	} else if (status == 'error') {
		$container.find('.status-error').show();
	} else {
		$container.find('.status-default-sm').show();
	}
}

function updateImportStats(type) {
	var stats = (type == 'customers') ? customersStats : ordersStats;
	
	if (stats.total > 0 && stats.synced > stats.total) {
		stats.synced = stats.total;
	}
	if (stats.success > stats.total) {
		stats.success = stats.total;
	}
	
	$('#val-' + type + '-total').text(stats.total > 0 ? stats.total : '-');
	$('#val-' + type + '-synced').text(stats.synced);
	$('#val-' + type + '-success').text(stats.success);
	$('#val-' + type + '-failed').text(stats.failed);
}

function checkImportCompletion() {
	if (isCustomersDone && isOrdersDone) {
		setStepStatus('step-import', 'success');
		
		if (!isModuleActive) {
			$.ajax({
				url: '<?php echo $set_active; ?>',
				type: 'post',
				dataType: 'json',
				success: function(json) {
					if(json['success']) {
						isModuleActive = true;
					}
				}
			});
		}
	}
}

function handleImportError(type, msg) {
	if (type === 'customers') custFailed = true;
	if (type === 'orders') ordersFailed = true;
	
	updateImportUI(type, 'error');
	setStepStatus('step-import', 'error');
	
	var $errorBox = $('.import-error-msg');
	var prefix = (type === 'customers') ? '<?php echo $text_failed; ?> <?php echo $text_contacts; ?>' : '<?php echo $text_failed; ?> <?php echo $text_orders; ?>';
	var currentHtml = $errorBox.html();
	
	if (currentHtml && currentHtml.indexOf(prefix) === -1) {
		$errorBox.html(currentHtml + '<br><b>' + prefix + ':</b> ' + msg);
	} else if (!currentHtml) {
		$errorBox.html('<b>' + prefix + ':</b> ' + msg);
	}
	
	$errorBox.show();
}

function getSiteScript(retryCount) {
	setStepStatus('step-tracking', 'loading');
	$.ajax({
		url: '<?php echo $get_site_script; ?>',
		type: 'post',
		dataType: 'json',
		success: function(json) {
			if (json['success']) {
				hasSiteScript = true;
				setStepStatus('step-tracking', 'success');
				$('#app-inbox-container').slideDown();
			} else {
				if (retryCount < maxRetries) {
					setTimeout(function() { getSiteScript(retryCount + 1); }, 3000);
				} else {
					setStepStatus('step-tracking', 'error');
				}
			}
		},
		error: function() {
			if (retryCount < maxRetries) {
				setTimeout(function() { getSiteScript(retryCount + 1); }, 3000);
			} else {
				setStepStatus('step-tracking', 'error');
			}
		}
	});
}

function addWebPush(retryCount) {
	setStepStatus('step-push', 'loading');
	$.ajax({
		url: '<?php echo $add_web_push; ?>',
		type: 'post',
		dataType: 'json',
		success: function(json) {
			if (json['success']) {
				hasWebPush = true;
				setStepStatus('step-push', 'success');
			} else {
				if (retryCount < maxRetries) {
					setTimeout(function() { addWebPush(retryCount + 1); }, 3000);
				} else {
					setStepStatus('step-push', 'error');
				}
			}
		},
		error: function() {
			if (retryCount < maxRetries) {
				setTimeout(function() { addWebPush(retryCount + 1); }, 3000);
			} else {
				setStepStatus('step-push', 'error');
			}
		}
	});
}

function startImports() {
	setStepStatus('step-import', 'loading');
	$('.import-desc.status-loading-msg').show();

	if (!custLoaded) {
		updateImportUI('customers', 'loading');
		updateImportStats('customers');
		loadCustomers(custPage);
	} else {
		updateImportUI('customers', 'success');
		updateImportStats('customers'); 
	}

	if (!ordersLoaded) {
		updateImportUI('orders', 'loading');
		updateImportStats('orders');
		loadOrders(ordersPage);
	} else {
		updateImportUI('orders', 'success');
		updateImportStats('orders');
	}

	checkImportCompletion();
}

function loadCustomers(page) {
	$.ajax({
		url: '<?php echo $load_customers; ?>',
		type: 'post',
		data: { page: page },
		dataType: 'json',
		success: function(json) {
			if (json['success']) {
				custRetries = 0; 
				if (json['total_customers']) {
					customersStats.total = parseInt(json['total_customers'], 10);
				}
				if (json['processed_count']) {
					customersStats.synced += parseInt(json['processed_count'], 10);
				}
				if (json['failed_count']) {
					customersStats.failed += parseInt(json['failed_count'], 10);
				}
				
				customersStats.success = Math.max(0, customersStats.synced - customersStats.failed);
				updateImportStats('customers');

				if (json['next_page']) {
					loadCustomers(json['next_page']);
				} else {
					isCustomersDone = true;
					custLoaded = true;
					updateImportUI('customers', 'success');
					customersStats.synced = customersStats.total;
					customersStats.success = Math.max(0, customersStats.total - customersStats.failed);
					updateImportStats('customers');
					checkImportCompletion();
				}
			} else {
				custRetries++;
				if (custRetries <= maxRetries) {
					setTimeout(function() { loadCustomers(page); }, 3000);
				} else {
					handleImportError('customers', '<?php echo $error_connection; ?>');
				}
			}
		},
		error: function() {
			custRetries++;
			if (custRetries <= maxRetries) {
				setTimeout(function() { loadCustomers(page); }, 3000);
			} else {
				handleImportError('customers', '<?php echo $error_connection; ?>');
			}
		}
	});
}

function loadOrders(page) {
	$.ajax({
		url: '<?php echo $load_orders; ?>',
		type: 'post',
		data: { page: page },
		dataType: 'json',
		success: function(json) {
			if (json['success']) {
				ordersRetries = 0; 
				if (json['total_orders']) {
					ordersStats.total = parseInt(json['total_orders'], 10);
				}
				if (json['processed_count']) {
					ordersStats.synced += parseInt(json['processed_count'], 10);
				}
				if (json['failed_count']) {
					ordersStats.failed += parseInt(json['failed_count'], 10);
				}
				
				ordersStats.success = Math.max(0, ordersStats.synced - ordersStats.failed);
				updateImportStats('orders');

				if (json['next_page']) {
					loadOrders(json['next_page']);
				} else {
					isOrdersDone = true;
					ordersLoaded = true;
					updateImportUI('orders', 'success');
					ordersStats.synced = ordersStats.total;
					ordersStats.success = Math.max(0, ordersStats.total - ordersStats.failed);
					updateImportStats('orders');
					checkImportCompletion();
				}
			} else {
				ordersRetries++;
				if (ordersRetries <= maxRetries) {
					setTimeout(function() { loadOrders(page); }, 3000);
				} else {
					handleImportError('orders', '<?php echo $error_connection; ?>');
				}
			}
		},
		error: function() {
			ordersRetries++;
			if (ordersRetries <= maxRetries) {
				setTimeout(function() { loadOrders(page); }, 3000);
			} else {
				handleImportError('orders', '<?php echo $error_connection; ?>');
			}
		}
	});
}

$('#step-tracking .btn-retry-step').on('click', function() {
	getSiteScript(1);
});

$('#step-push .btn-retry-step').on('click', function() {
	addWebPush(1);
});

$('#step-import .btn-retry-import').on('click', function() {
	$('.import-error-msg').hide().empty();
	setStepStatus('step-import', 'loading');
	
	if (custFailed) {
		custFailed = false;
		custRetries = 0;
		updateImportUI('customers', 'loading');
		loadCustomers(custPage);
	}
	if (ordersFailed) {
		ordersFailed = false;
		ordersRetries = 0;
		updateImportUI('orders', 'loading');
		loadOrders(ordersPage);
	}
});

$('#btn-app-inbox').on('click', function() {
	var $btn = $(this);
	$btn.prop('disabled', true);
	
	$.ajax({
		url: '<?php echo $toggle_app_inbox; ?>',
		type: 'post',
		dataType: 'json',
		success: function(json) {
			if (json['success']) {
				if (json['new_status'] === '1') {
					$btn.attr('data-status', '1').text('<?php echo $button_disable; ?>');
					$('#badge-app-inbox').removeClass('disabled').addClass('enabled').text('<?php echo $text_enabled; ?>');
				} else {
					$btn.attr('data-status', '0').text('<?php echo $button_enable; ?>');
					$('#badge-app-inbox').removeClass('enabled').addClass('disabled').text('<?php echo $text_disabled; ?>');
				}
			}
			$btn.prop('disabled', false);
		},
		error: function() {
			$btn.prop('disabled', false);
		}
	});
});
</script>
<?php echo $footer; ?>