class AddPropsectsFileToStore < ActiveRecord::Migration
  def change
    add_column :stores, :propects_file, :string
  end
end
