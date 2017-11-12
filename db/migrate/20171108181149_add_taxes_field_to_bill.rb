class AddTaxesFieldToBill < ActiveRecord::Migration
  def change
    add_column :bills, :taxes, :float
  end
end
