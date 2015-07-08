# BusinessEmailEnquiry Rake Task:: Rake task to send business enquiry mails & fetching the auto-response.
# 
# Author::    Janmejay Rai (mailto: janmejay.rai31@gmail.com)
# Copyright:: Subco Devs
# License::   Without a license, the code is copyrighted by default. People can read the code, but they have no legal right to use it. To use the code, you must contact the author directly and ask permission.

namespace :business_email_inquiry do

	desc "Send automated emails business enquiry email."
	task :send_inquiry => :environment do
		BusinessEnquiry.send_business_enquiry
	end

	desc "Fetch the auto-response from the mails."
	task :fetch_mails,[:date, :user_name, :password] => :environment do |t, args|
		BusinessEnquiry.fetch_email(args[0], args[1], args[3])
	end

	desc "Downloading the data."
	task :download_data => :environment do
		BusinessEnquiry.download_enquiry_data
	end
end