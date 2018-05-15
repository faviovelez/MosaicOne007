class AddDaysBeforeToStore < ActiveRecord::Migration
  def change
    add_column :stores, :days_before, :integer, default: 3
  end
end
