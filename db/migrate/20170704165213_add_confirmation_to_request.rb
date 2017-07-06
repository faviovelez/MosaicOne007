class AddConfirmationToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :authorised, :boolean
  end
end
