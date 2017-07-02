class RemoveDocumentFromDocument < ActiveRecord::Migration
  def change
    remove_column :documents, :document, :string
  end
end
