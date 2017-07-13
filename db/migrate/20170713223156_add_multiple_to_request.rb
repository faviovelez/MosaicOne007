class AddMultipleToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :payment, :string
    add_column :requests, :authorisation, :string
  end
end
