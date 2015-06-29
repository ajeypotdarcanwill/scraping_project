class BusinessEnquiry < ActiveRecord::Base

	def self.send_business_enquiry
		agent = Mechanize.new
		url = "http://www.yellowpages.ca/bus/Ontario/Mississauga/Gabriel-s-Restaurant-Bar-Grill/2280895.html?what=restaurants&where=Mississauga,+ON&useContext=true"
		# BusinessUrl.all.each do |url|
			agent.get(url)
			page = agent.page
			str = ""
			link = page.link_with(text: "Email")
			if link.present?
				unique_identifier = rand.to_s[2..10].to_i     #this will generate a 9 digit random unique number
				business_name = page.search("h1.merchantInfo-title").first.children.first.children.first.text
				business_address = page.search("address.merchant-address").first.children.each{|x| str = str + " " + x.children.first if !x.children.first.nil?}
				BusinessEnquiry.create(unique_id: unique_identifier, business_name: business_name, business_address: business_address)
			end
		# end
	end

	def self.fetch_email(date)
		date = Date.parse(date) if date.is_a?(String)
		gmail = Gmail.connect!(Constants::EMAIL_USERNAME, Constants::EMAIL_PASSWORD)
		emails = gmail.inbox.find(:unread, on: date, from: Constants::FROM_EMAIL)
		emails.each do |email|
			message = email.message
			business_email_address = message.to.first
			email_body = message.text_part.body.raw_source
			identifier = email_body.scan(/\d+/).map(&:to_i).first
			check_identifier = BusinessEnquiry.where(unique_id: identifier)
			if check_identifier.present?
				BusinessEnquiry.update_attributes(email_address: business_email_address)
			end
		end
	end
end