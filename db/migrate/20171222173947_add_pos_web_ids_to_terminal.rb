class AddPosWebIdsToTerminal < ActiveRecord::Migration
  def change
    add_column :terminals, :pos_id, :integer
    add_column :terminals, :web_id, :integer
  end
end
