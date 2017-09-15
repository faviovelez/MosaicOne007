class RemoveStatusFromStore < ActiveRecord::Migration
  def change
    remove_column :stores, :prospect_status, :string
  end
end
