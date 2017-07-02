class RemoveDocumentsFromDocument < ActiveRecord::Migration
  def change
    remove_column :documents, :documents, :json
  end
end
