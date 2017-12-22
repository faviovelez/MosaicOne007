class AddPosWebIdsToServices < ActiveRecord::Migration
  def change
    add_column :services, :pos_id, :integer
    add_column :services, :web_id, :integer
  end
end
