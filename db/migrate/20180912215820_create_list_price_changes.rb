class CreateListPriceChanges < ActiveRecord::Migration
  def change
    create_table :list_price_changes do |t|
      t.references :user, index: true, foreign_key: true
      t.string :document_list

      t.timestamps null: false
    end
  end
end
