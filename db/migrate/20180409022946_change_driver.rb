class ChangeDriver < ActiveRecord::Migration
  def change
    change_column :drivers, :active, :boolean, default: true
  end
end
