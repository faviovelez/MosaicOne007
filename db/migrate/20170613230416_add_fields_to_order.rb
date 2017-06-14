class AddFieldsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :category, :string
    add_column :orders, :times_ordered, :integer
  end
end
