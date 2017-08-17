class AddLastfolioToSupplier < ActiveRecord::Migration
  def change
    add_column :suppliers, :last_purhcase_folio, :string
  end
end
