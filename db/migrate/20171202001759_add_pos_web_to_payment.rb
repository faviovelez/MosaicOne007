class AddPosWebToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :pos, :boolean, default: false
    add_column :payments, :web, :boolean, default: true
    add_column :payments, :date, :date
  end
end
