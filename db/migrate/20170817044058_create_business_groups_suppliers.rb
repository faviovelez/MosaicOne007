class CreateBusinessGroupsSuppliers < ActiveRecord::Migration
  def change
    create_table :business_groups_suppliers do |t|
      t.references :business_group, index: true, foreign_key: true
      t.references :supplier, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
