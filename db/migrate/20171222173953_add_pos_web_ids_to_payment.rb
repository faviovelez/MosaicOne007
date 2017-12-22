class AddPosWebIdsToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :pos_id, :integer
    add_column :payments, :web_id, :integer
  end
end
