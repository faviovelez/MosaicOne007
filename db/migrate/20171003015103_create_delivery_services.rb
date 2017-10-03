class CreateDeliveryServices < ActiveRecord::Migration
  def change
    create_table :delivery_services do |t|
      t.string :sender_name
      t.string :sender_zipcode
      t.string :tracking_number
      t.string :receivers_name
      t.string :contact_name
      t.string :street
      t.string :exterior_number
      t.string :interior_number
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :country
      t.string :phone
      t.string :cellphone
      t.string :email
      t.string :company
      t.references :service_offered, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
