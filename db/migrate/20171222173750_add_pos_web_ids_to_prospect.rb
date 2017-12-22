class AddPosWebIdsToProspect < ActiveRecord::Migration
  def change
    add_column :prospects, :pos_id, :integer
    add_column :prospects, :web_id, :integer
  end
end
