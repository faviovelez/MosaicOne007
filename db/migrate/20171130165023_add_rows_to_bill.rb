class AddRowsToBill < ActiveRecord::Migration
  def change
    add_column :bills, :rows, :text, array: true, default: []
  end
end
