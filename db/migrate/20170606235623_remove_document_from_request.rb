class RemoveDocumentFromRequest < ActiveRecord::Migration
  def change
    remove_reference :requests, :document, index: true, foreign_key: true
  end
end
