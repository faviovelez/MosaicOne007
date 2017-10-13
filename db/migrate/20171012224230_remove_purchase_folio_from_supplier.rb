class RemovePurchaseFolioFromSupplier < ActiveRecord::Migration
  def change
    remove_column :suppliers, :last_purhcase_folio, :string
  end
end
