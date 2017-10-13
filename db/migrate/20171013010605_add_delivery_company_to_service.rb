class AddDeliveryCompanyToService < ActiveRecord::Migration
  def change
    add_column :services, :delivery_company, :string
  end
end
