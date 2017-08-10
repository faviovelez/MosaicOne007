class AddSomeToProspectSale < ActiveRecord::Migration
  def change
    remove_column :prospect_sales, :month, :string
    remove_column :prospect_sales, :year, :string
    add_column :prospect_sales, :month, :integer
    add_column :prospect_sales, :year, :integer

  end
end
