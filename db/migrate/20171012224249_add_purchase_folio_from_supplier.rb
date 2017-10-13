class AddPurchaseFolioFromSupplier < ActiveRecord::Migration
  def change
    add_column :suppliers, :last_purchase_folio, :string
  end
end
