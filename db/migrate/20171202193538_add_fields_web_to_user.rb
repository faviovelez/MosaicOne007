class AddFieldsWebToUser < ActiveRecord::Migration
  def change
    add_column :users, :web, :boolean
    add_column :users, :pos, :boolean
    add_column :users, :date, :date
  end
end
