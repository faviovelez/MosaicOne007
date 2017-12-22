class AddPosWebIdsToBillingAddress < ActiveRecord::Migration
  def change
    add_column :billing_addresses, :pos_id, :integer
    add_column :billing_addresses, :web_id, :integer
  end
end
