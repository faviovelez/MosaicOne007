class CreateRequestUsers < ActiveRecord::Migration
  def change
    create_table :request_users do |t|
      t.references :request, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
