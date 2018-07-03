class AddAuthorisedWithoutPrintcardToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :authorised_without_printcard, :boolean
  end
end
