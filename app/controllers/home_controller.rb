class HomeController < ApplicationController

	def index
	  @business_enquiries = BusinessEnquiry.all
	end
	
  # Sends business enquiry to provided url.
	def send_mail
	  status = BusinessEnquiry.send_enquiry(params[:business_url])
	  if status == "success"
	   BusinessUrl.create(url: params[:business_url], enquiry_sent: true)
	   redirect_to '/', notice: "Business enquiry sent."
	  else
	    redirect_to '/', alert: "Could not find Email link on this webpage. Enquiry sending failed."
    end
	end
	
	# to send multiple business enquiries, sends enquiries to all urls where enquiry_sent is false.
	def send_enquiries
    BusinessEnquiry.send_business_enquiry
	  redirect_to business_urls_path, notice: "Business enquiries sent to the urls where email address was present."
	end
	
	# Fetch to-emails from gmail received emails from yp.com
	def fetch_emails
	 BusinessEnquiry.fetch_email(Constants::GMAIL_USER, Constants::GMAIL_PASSWORD)
	 redirect_to '/', notice: "Emails fetched."
	end
	
	# Downloads business enquiry data in MS Excel file, only the records where emails ids are present.
	def download_data
	 file = BusinessEnquiry.download_enquiry_data
   send_data file, :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", filename: "business_enquiries_#{Date.today}.xlsx"
	end
	
	# accepts uploaded csv file and imports business urls from csv file to database.
	def import_data
	 BusinessEnquiry.import(params[:file])
	 redirect_to business_urls_path, notice: "Business urls imported."
	end
	
	# Business urls page, where urls are separately shown sent/to-be-sent.
	def business_urls
	 @unsent_urls = BusinessUrl.where(enquiry_sent: false)
	 @sent_urls = BusinessUrl.where(enquiry_sent: true)
	end
	
end