class AddServiceToServiceSale < ActiveRecord::Migration
  def change
    add_reference :service_sales, :service, index: true, foreign_key: true
  end
end
