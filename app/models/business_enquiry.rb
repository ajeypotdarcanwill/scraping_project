# BusinessEnquiry:: Program to send business enquiry, fetch email from auto response & download business owner's details.
# 
# Author::    Janmejay Rai (mailto: janmejay.rai31@gmail.com)
# Copyright:: Subco Devs
# License::   Without a license, the code is copyrighted by default. People can read the code, but they have no legal right to use it. To use the code, you must contact the author directly and ask permission.

class BusinessEnquiry < ActiveRecord::Base
  
  default_scope { order(created_at: :desc) }

	# Method to send the business enquiry using the url's provided.
	# 
	# +result+:: an email will be send to the business owner if the email link is present on the url which is being hit.

	def self.send_business_enquiry
		BusinessUrl.where(enquiry_sent: false).first(20).each do |business_url|
			send_enquiry(business_url.url)
		end
	end
	
	def self.send_enquiry(business_url)
	  agent = Mechanize.new
	  Rails.logger.info "------ Visiting the url: #{business_url} ------"
		agent.get(business_url)
		page = agent.page
		Rails.logger.info ""
		Rails.logger.info "------ Fetched the required page ------"
		Rails.logger.info ""
		str = ""
		link = page.link_with(text: "Email")
		form_url = "http://www.yellowpages.ca/ajax/email"
		if link.present?

			#this will generate a 9 digit random unique number
			unique_identifier = rand.to_s[2..10].to_i

			#finding the business name.
			business_name = page.search("h1.merchantInfo-title").first.children.first.children.first.text

			#finding the address of the business owner.
			page.search("address.merchant-address").first.children.each{|x| str = str + " " + x.children.first if !x.children.first.nil?}
			business_address = str

			email_xpath = page.parser.xpath("//div[@class='merchantHead']/div[2]/ul/li[4]/a")

			#finding the id of the business from the url.
			business_id = business_url.split('/').last.split('.').first.to_s

			#params for the form.
			from_email = "michaelstarc1984@gmail.com"
			body_content = "I would like to know the timings please. (" + "#{unique_identifier}" + ")"
			params = { id: business_id, from: from_email, contentEmail: body_content, copyToSender: 'on' }    # params required on the form.

			Rails.logger.info "------- Sending the business enquiry mail ------"
			Rails.logger.info ""

			#sending business enquiry mail using rest-client gem and passing the url & params as arguments.
			RestClient.post(form_url, params)

			#creating a database entry for BusinessEnquiry.
			BusinessEnquiry.create(unique_id: unique_identifier, business_name: business_name, business_address: business_address)
			
			#Updating the business url database entry as sent
      if url = BusinessUrl.where(url: business_url).first
        url.update_attributes(enquiry_sent: true)
      end
			
			Rails.logger.info "-------- Business Enquiry email sent successfully. -------"
			Rails.logger.info ""
			return "success"
		else
			Rails.logger.info "------- Could not find Email link. Not able to send the enquiry mail."
			Rails.logger.info ""
			return "Fail"
		end
	end

	# Method to fetch the emails received in inbox as autoresponse.
	# 
	# Params:
	# +date+:: date for which emails needs to be fetched.
	# +user_name+:: email address for which the email has to be retrived.
	# +user_password+:: password of the email address.
	#
	# +result+:: email will be fetched and 'to address' will be saved in the database if the identifier in the mail body matches with the database.

	def self.fetch_email(user_name, user_password)
    # date = Date.parse(date) if date.is_a?(String)

		Rails.logger.info "------ Connecting to Gmail using the specified credentials --------"
		Rails.logger.info ""
		gmail = Gmail.connect!(user_name, user_password)

		Rails.logger.info "------ Gmail connected. Now reading the emails for the specified date --------"
		Rails.logger.info ""
		emails = gmail.inbox.find(:unread, from: Constants::FROM_EMAIL)

		if emails.present?
			emails.each do |email|
				Rails.logger.info "-------- Fetching the message from the email -------"
				Rails.logger.info ""

				#fetching the message from the email.
				message = email.message

				#fetching the 'to email address'
				business_email_address = message.to_addrs.first

				#fetching the email body & finding out the unique identifier.
				identifier = message.html_part.body.raw_source.scan(/\d+/).map(&:to_i)

				#checking the unique identifier with the database value.
				identifier.each do |iden|
					business_enquiry = BusinessEnquiry.where(unique_id: iden)
					if business_enquiry.present?
						business_enquiry.first.update_attributes(email_address: business_email_address, has_email_address: true)
						break
					end
				end
				
				# mark this email as read.
				email.read!
				
				Rails.logger.info "-------- Email address of Business Owner fetched successfully ---------"
			end
		else
			Rails.logger.info "-------- Could not find any unread email. -------"
		end
	end

	# Method to download the enquiry data as excel spread sheet.
	# 
	# +result+:: excel spread sheet will be downloaded if there is data in the database.

	def self.download_enquiry_data
		p = Axlsx::Package.new
		wb = p.workbook
		wb.styles do |s|
			first_cell = s.add_style(:b => true,:font_name => "Calibri")
			wb.add_worksheet(:name => "Enquiry Data") do |sheet|
				sheet.add_row ["Business Name", "Business Address", "Business Email Address"]
				BusinessEnquiry.where(has_email_address: true).each do |be|
					sheet.add_row [be.business_name, be.business_address, be.email_address]
				end
			end
		end
    # p.serialize("#{Rails.root}/public/enquiry_sheet.xlsx")
    return p.to_stream.read
	end
	
	# Method to import urls from csv file
	def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
	    BusinessUrl.create! row.to_hash
    end
	end
end





