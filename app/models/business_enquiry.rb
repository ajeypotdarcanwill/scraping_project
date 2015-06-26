class BusinessEnquiry < ActiveRecord::Base

	def send_business_enquiry
		agent = Mechanize.new
		url = "http://www.yellowpages.ca/bus/Ontario/Mississauga/Gabriel-s-Restaurant-Bar-Grill/2280895.html?what=restaurants&where=Mississauga,+ON&useContext=true"
		BusinessUrl.all.each do |url|
			agent.get(url)
			page = agent.page
			link = page.link_with(text: "Email")
			if link.present?
			end
		end
	end
end