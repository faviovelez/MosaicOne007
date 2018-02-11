class ChangeDefaultToServices < ActiveRecord::Migration
  def change
    change_column :services, :shared, :boolean, default: true
  end
end
