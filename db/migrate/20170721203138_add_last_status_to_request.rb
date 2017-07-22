class AddLastStatusToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :last_status, :string
  end
end
