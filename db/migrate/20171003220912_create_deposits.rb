class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.references :user, index: true, foreign_key: true
      t.references :store, index: true, foreign_key: true
      t.float :amount

      t.timestamps null: false
    end
  end
end
