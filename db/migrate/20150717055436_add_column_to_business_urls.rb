class AddColumnToBusinessUrls < ActiveRecord::Migration
  def change
    add_column :business_urls, :enquiry_sent, :boolean, default: false
  end
end
