class AddHasEmailAddressToBusinessEnquiry < ActiveRecord::Migration
	def change
		add_column :business_enquiries, :has_email_address, :boolean, default: false

		remove_column :business_enquiries, :business_owner_name, :string
	end
end