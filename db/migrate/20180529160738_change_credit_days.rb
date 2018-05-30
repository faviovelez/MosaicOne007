class ChangeCreditDays < ActiveRecord::Migration
  def change
    change_column :prospects, :credit_days, :integer, default: 0
  end
end
