class CreateTaxRegimes < ActiveRecord::Migration
  def change
    create_table :tax_regimes do |t|
      t.string :description

      t.timestamps null: false
    end
  end
end
