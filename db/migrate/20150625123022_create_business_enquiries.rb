class CreateBusinessEnquiries < ActiveRecord::Migration
	def change
		create_table :business_enquiries do |t|
			t.string :email_address
			t.string :business_owner_name
			t.string :business_name
			t.string :business_address
			t.string :unique_id

			t.timestamps null: false
		end
	end
end