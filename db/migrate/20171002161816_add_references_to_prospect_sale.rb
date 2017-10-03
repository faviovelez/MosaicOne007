class AddReferencesToProspectSale < ActiveRecord::Migration
  def change
    add_reference :prospect_sales, :store, index: true, foreign_key: true
    add_reference :prospect_sales, :business_unit, index: true, foreign_key: true
  end
end
