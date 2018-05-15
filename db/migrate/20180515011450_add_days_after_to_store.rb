class AddDaysAfterToStore < ActiveRecord::Migration
  def change
    add_column :stores, :days_after, :integer, default: 5
    add_column :stores, :collection_active, :boolean, default: true
    add_column :prospects, :collection_active, :boolean, default: true
  end
end
