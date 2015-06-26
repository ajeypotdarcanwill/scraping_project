class CreateBusinessUrls < ActiveRecord::Migration
	def change
		create_table :business_urls do |t|
			t.string :url

			t.timestamps null: false
		end
	end
end