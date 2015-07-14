class HomeController < ApplicationController

	def index
	  @business_enquiries = BusinessEnquiry.all
	end

	def send_mail
	  status = BusinessEnquiry.send_enquiry(params[:business_url])
	  logger.info "~~~~~~~~~~~~~~#{status}~~~~~~~~~~~~~~~~"
	  if status == "success"
	   BusinessUrl.create(url: params[:business_url])
	   redirect_to '/', notice: "Business enquiry sent."
	  else
	    redirect_to '/', alert: "Could not find Email link. Not able to send the enquiry."
    end
	end
	
end