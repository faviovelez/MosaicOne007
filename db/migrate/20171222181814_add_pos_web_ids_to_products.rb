class AddPosWebIdsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :pos_id, :integer
    add_column :products, :web_id, :integer
  end
end
