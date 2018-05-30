class AddCorporateToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :corporate, index: true, default: 1
  end
end
