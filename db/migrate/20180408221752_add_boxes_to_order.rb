class AddBoxesToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :boxes, :integer
  end
end
