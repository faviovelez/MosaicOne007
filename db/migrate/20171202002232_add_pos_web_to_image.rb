class AddPosWebToImage < ActiveRecord::Migration
  def change
    add_column :images, :pos, :boolean, default: false
    add_column :images, :web, :boolean, default: false
    add_column :images, :date, :date
  end
end
