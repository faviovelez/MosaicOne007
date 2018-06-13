class AddStatusToBillReceived < ActiveRecord::Migration
  def change
    add_column :bill_receiveds, :status, :string, default: 'activa'
  end
end
