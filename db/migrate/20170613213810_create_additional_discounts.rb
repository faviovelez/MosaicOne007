class CreateAdditionalDiscounts < ActiveRecord::Migration
  def change
    create_table :additional_discounts do |t|
      t.string :type_of_discount
      t.float :percentage

      t.timestamps null: false
    end
  end
end
