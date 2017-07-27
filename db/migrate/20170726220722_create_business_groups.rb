class CreateBusinessGroups < ActiveRecord::Migration
  def change
    create_table :business_groups do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
