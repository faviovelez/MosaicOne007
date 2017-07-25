class CreateDeliveryAttempts < ActiveRecord::Migration
  def change
    create_table :delivery_attempts do |t|
      t.references :product_request, index: true, foreign_key: true
      t.references :order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
