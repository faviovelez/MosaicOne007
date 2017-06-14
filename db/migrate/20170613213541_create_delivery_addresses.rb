class CreateDeliveryAddresses < ActiveRecord::Migration
  def change
    create_table :delivery_addresses do |t|
      t.string :street
      t.string :exterior_number
      t.string :interior_number
      t.string :zipcode
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :country
      t.string :additional_references
      t.references :prospect, index: true, foreign_key: true
      t.string :type_of_address

      t.timestamps null: false
    end
  end
end
