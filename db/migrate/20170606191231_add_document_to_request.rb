class AddDocumentToRequest < ActiveRecord::Migration
  def change
    add_reference :requests, :document, index: true, foreign_key: true
  end
end
