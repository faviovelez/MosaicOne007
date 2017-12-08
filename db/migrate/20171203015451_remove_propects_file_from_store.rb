class RemovePropectsFileFromStore < ActiveRecord::Migration
  def change
    remove_column :stores, :propects_file, :string
    add_column :stores, :prospects_file, :string
  end
end
