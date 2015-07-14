class UserMailer < ApplicationMailer
	default from: "me@gmail.com"

	def send_business_enquiry(email, message)
		@user_email = email
		@message = message
		mail(to: @user_email, subject: "YellowPages.ca User Enquiry")
	end
end