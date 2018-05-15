class AddActiveToDateAdvise < ActiveRecord::Migration
  def change
    add_column :date_advises, :active, :boolean, default: true
    remove_column :date_advises, :sent, :boolean
  end
end
