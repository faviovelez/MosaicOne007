class AddSpecificationsToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :specification, :string
  end
end
