class AddCreditStatusToBusinessUnit < ActiveRecord::Migration
  def change
    add_column :business_units, :current, :boolean
    add_column :business_units, :pending_balance, :float
  end
end
