class AddBillReceivedReferenceToDocument < ActiveRecord::Migration
  def change
    add_reference :documents, :bill_received, index: true, foreign_key: true
  end
end
