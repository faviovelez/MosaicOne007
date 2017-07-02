class AddAnotherToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :authorisation, :boolean
    add_column :requests, :payment, :boolean
  end
end
