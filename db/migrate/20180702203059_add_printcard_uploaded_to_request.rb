class AddPrintcardUploadedToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :printcard_uploaded, :string
  end
end
