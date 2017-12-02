class AddCurrentToServices < ActiveRecord::Migration
  def change
    add_column :services, :current, :boolean
  end
end
