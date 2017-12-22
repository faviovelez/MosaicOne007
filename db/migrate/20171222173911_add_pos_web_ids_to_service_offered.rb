class AddPosWebIdsToServiceOffered < ActiveRecord::Migration
  def change
    add_column :service_offereds, :pos_id, :integer
    add_column :service_offereds, :web_id, :integer
  end
end
