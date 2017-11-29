class AddFromToBill < ActiveRecord::Migration
  def change
    add_column :bills, :from, :string
  end
end
