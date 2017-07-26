class AddPiecesToProduct < ActiveRecord::Migration
  def change
    add_column :products, :pieces_per_package, :integer
  end
end
