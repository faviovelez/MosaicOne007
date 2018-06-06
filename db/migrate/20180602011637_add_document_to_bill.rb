class AddDocumentToBill < ActiveRecord::Migration
  def change
    add_reference :documents, :bill, index: true, foreign_key: true
  end
end
