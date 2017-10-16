class AddSeriesToStore < ActiveRecord::Migration
  def change
    add_column :stores, :series, :string
    add_column :stores, :last_bill, :integer, default: 0
  end
end
