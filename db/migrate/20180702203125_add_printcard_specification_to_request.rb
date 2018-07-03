class AddPrintcardSpecificationToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :printcard_document, :boolean
  end
end
