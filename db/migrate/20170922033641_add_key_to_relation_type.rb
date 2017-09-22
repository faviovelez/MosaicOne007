class AddKeyToRelationType < ActiveRecord::Migration
  def change
    add_column :relation_types, :key, :string
  end
end
