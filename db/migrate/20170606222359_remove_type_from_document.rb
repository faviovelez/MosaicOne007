class RemoveTypeFromDocument < ActiveRecord::Migration
  def change
    remove_column :documents, :type, :string
  end
end
