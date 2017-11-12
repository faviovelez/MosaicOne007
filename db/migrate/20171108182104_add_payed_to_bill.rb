class AddPayedToBill < ActiveRecord::Migration
  def change
    add_column :bills, :payed, :boolean, default: false
  end
end
