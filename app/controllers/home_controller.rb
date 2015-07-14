class HomeController < ApplicationController

	def index
	  @business_enquiries = BusinessEnquiry.all
	end

	def send_mail
		email = ""
		message = ""
		begin
			Thread.new do
				UserMailer.send_business_enquiry(email, message).deliver_now!
			end
		rescue Exception => e
			puts e.message
		end
		redirect_to '/', notice: "Mail send"
	end
	
  # def business_enquiries
  #  @business_enquiries = BusinessEnquiry.all
  # end
	
end