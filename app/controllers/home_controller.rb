class HomeController < ApplicationController

	def index
	  @business_enquiries = BusinessEnquiry.all
	end
	
  # Sends business enquiry to provided url.
	def send_mail
	  status = BusinessEnquiry.send_enquiry(params[:business_url])
	  if status == "success"
	   BusinessUrl.create(url: params[:business_url])
	   redirect_to '/', notice: "Business enquiry sent."
	  else
	    redirect_to '/', alert: "Could not find Email link on this webpage. Enquiry sending failed."
    end
	end
	
	# Fetch emails from gmail received emails.
	def fetch_emails
	 BusinessEnquiry.fetch_email("michaelstarc1984@gmail.com", "michael@12345")
	 redirect_to '/', notice: "Emails fetched."
	end
	
	# Downloads business enquiry data in MS Excel file, only the records where emails ids are present.
	def download_data
	 file = BusinessEnquiry.download_enquiry_data
   send_data file, :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", filename: "business_enquiries_#{Date.today}.xlsx"
	end
	
end