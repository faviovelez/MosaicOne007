class AddPosWebToBank < ActiveRecord::Migration
  def change
    add_column :banks, :pos, :boolean, default: false
    add_column :banks, :web, :boolean, default: true
    add_column :banks, :date, :date
  end
end
