class CreateDeliveryPackages < ActiveRecord::Migration
  def change
    create_table :delivery_packages do |t|
      t.float :lenght
      t.float :width
      t.float :height
      t.float :weight
      t.references :order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
