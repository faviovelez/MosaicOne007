class AddPosWebIdsToUser < ActiveRecord::Migration
  def change
    add_column :users, :pos_id, :integer
    add_column :users, :web_id, :integer
  end
end
