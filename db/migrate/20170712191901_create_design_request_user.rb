class CreateDesignRequestUser < ActiveRecord::Migration
  def change
    create_table :design_request_users do |t|
      t.references :design_request, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
    end
  end
end
