class AddFieldToDocument < ActiveRecord::Migration
  def change
    add_reference :documents, :design_request, index: true, foreign_key: true
  end
end
