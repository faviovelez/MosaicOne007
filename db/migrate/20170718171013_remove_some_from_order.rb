class RemoveSomeFromOrder < ActiveRecord::Migration
  def change
    remove_reference :orders, :product, index: true, foreign_key: true
    remove_column :orders, :times_ordered, :integer
  end
end
