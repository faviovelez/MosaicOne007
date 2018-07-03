class AddPrintcardToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :printcard, :string
  end
end
