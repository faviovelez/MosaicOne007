class AddFieldsToTaxRegime < ActiveRecord::Migration
  def change
    add_column :tax_regimes, :tax_id, :integer
    add_column :tax_regimes, :corporate, :boolean
    add_column :tax_regimes, :particular, :boolean
    add_column :tax_regimes, :date_since, :date
  end
end
