class AddPosWebIdsToBank < ActiveRecord::Migration
  def change
    add_column :banks, :pos_id, :integer
    add_column :banks, :web_id, :integer
  end
end
