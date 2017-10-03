class CreateServiceOffereds < ActiveRecord::Migration
  def change
    create_table :service_offereds do |t|
      t.references :service, index: true, foreign_key: true
      t.references :store, index: true, foreign_key: true
      t.references :business_unit, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
