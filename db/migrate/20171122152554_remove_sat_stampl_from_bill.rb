class RemoveSatStamplFromBill < ActiveRecord::Migration
  def change
    remove_column :bills, :sat_stampl, :string
    add_column :bills, :sat_stamp, :string
  end
end
