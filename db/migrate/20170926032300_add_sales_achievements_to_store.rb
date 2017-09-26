class AddSalesAchievementsToStore < ActiveRecord::Migration
  def change
    add_column :stores, :period_sales_achievement, :boolean
    add_column :stores, :inspection_approved, :boolean
  end
end
