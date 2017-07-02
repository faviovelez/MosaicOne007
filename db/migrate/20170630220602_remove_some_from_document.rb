class RemoveSomeFromDocument < ActiveRecord::Migration
  def change
    remove_column :documents, :documents, :string
  end
end
