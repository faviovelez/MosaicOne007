class CreateBillingAddresses < ActiveRecord::Migration
  def change
    create_table :billing_addresses do |t|
      t.string :type_of_person
      t.string :business_name
      t.string :rfc
      t.string :street
      t.string :exterior_number
      t.string :interior_number
      t.integer :zipcode
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :country
      t.string :type_of_bill
      t.string :bill_for_who
      t.string :classification

      t.timestamps null: false
    end
  end
end
