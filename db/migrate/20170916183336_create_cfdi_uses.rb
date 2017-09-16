class CreateCfdiUses < ActiveRecord::Migration
  def change
    create_table :cfdi_uses do |t|
      t.string :description

      t.timestamps null: false
    end
  end
end
