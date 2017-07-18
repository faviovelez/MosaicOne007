class AddTimesToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :times_ordered, :integer
  end
end
