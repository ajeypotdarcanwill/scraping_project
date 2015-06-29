namespace :business_email_inquiry do

	desc "Send automated emails business enquiry email."
	task :send_inquiry => :environment do
		BusinessEnquiry.send_business_enquiry
	end

	desc "Fetch the auto-response from the mails."
	task :fetch_mails,[:date, :user_name, :password] => :environment do |t, args|
		BusinessEnquiry.fetch_email(args[0], args[1], args[3])
	end
end