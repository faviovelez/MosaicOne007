class AddPosWebToProspect < ActiveRecord::Migration
  def change
    add_column :prospects, :pos, :boolean, default: false
    add_column :prospects, :web, :boolean, default: true
    add_column :prospects, :date, :date
  end
end
