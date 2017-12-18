class AddBillFolioTypeToBill < ActiveRecord::Migration
  def change
    add_column :bills, :bill_folio_type, :string
  end
end
