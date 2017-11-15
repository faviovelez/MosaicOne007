class RemoveManyFieldsFromBill < ActiveRecord::Migration
  def change
    remove_column :bills, :initial_price, :float
    remove_column :bills, :price_before_taxes, :float
    remove_column :bills, :type_of_bill, :string
    remove_column :bills, :classification, :string
    remove_column :bills, :quantity, :string
    remove_column :bills, :expedition_zip_id, :integer
    remove_column :bills, :fiscal_folio, :string
    remove_column :bills, :digital_stamp, :string
    remove_column :bills, :certificate, :string
    remove_column :bills, :sat_stamp, :string
    remove_column :bills, :original_chain, :string
    remove_column :bills, :amount, :float
  end
end
