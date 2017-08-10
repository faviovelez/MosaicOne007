class ChangeDefaultToProduct < ActiveRecord::Migration
  def change
    change_column :products, :pieces_per_package, :integer, :default => 1
    change_column :products, :number_of_pieces, :integer, :default => 1
    change_column :products, :accesories_kit, :string, :default => 'ninguno'
  end
end
