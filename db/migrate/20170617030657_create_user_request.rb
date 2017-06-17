class CreateUserRequest < ActiveRecord::Migration
  def change
    create_table :user_requests do |t|
      t.references :user, index: true, foreign_key: true
      t.references :request, index: true, foreign_key: true
    end
  end
end
