class AddCorporateToProductRequests < ActiveRecord::Migration
  def change
    add_reference :product_requests, :corporate, index: true, default: 1
  end
end
