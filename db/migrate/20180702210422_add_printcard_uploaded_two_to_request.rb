class AddPrintcardUploadedTwoToRequest < ActiveRecord::Migration
  def change
    remove_column :requests, :printcard_uploaded, :string
    add_column :requests, :printcard_uploaded, :boolean
  end
end
