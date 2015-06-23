Rails.Application.configure do
	config.action_mailer.delivery_method = :smtp
	config.action_mailer.perform_deliveries = true
	config.action_mailer.raise_delivery_errors = true
	config.action_mailer.default :charset => "utf-8"
	config.action_mailer.smtp_settings = {
		address: "",
		port: 587,
		domain: "",
		authentication: "plain",
		enable_starttls_auto: true,
		user_name: "",
		password: ""
	}
end