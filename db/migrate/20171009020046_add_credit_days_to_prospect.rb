class AddCreditDaysToProspect < ActiveRecord::Migration
  def change
    add_column :prospects, :credit_days, :integer
  end
end
