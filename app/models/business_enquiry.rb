class BusinessEnquiry < ActiveRecord::Base

	def self.send_business_enquiry
		agent = Mechanize.new
		# url = "http://www.yellowpages.ca/bus/Ontario/Mississauga/Gabriel-s-Restaurant-Bar-Grill/2280895.html?what=restaurants&where=Mississauga,+ON&useContext=true"
		BusinessUrl.all.each do |url|
			agent.get(url)
			page = agent.page
			link = page.link_with(text: "Email")
			if link.present?
			end
		end
	end

	def self.fetch_email(date)
		date = Date.parse(date) if date.is_a?(String)
		gmail = Gmail.connect!(Constants::EMAIL_USERNAME, Constants::EMAIL_PASSWORD)
		emails = gmail.inbox.find(:unread, on: date, from: Constants::FROM_EMAIL)
		email.each do |email|
			message = email.message
			business_email_address = message.to.first
			email_body = message.body
		end
	end
end