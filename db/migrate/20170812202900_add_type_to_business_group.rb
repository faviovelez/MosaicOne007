class AddTypeToBusinessGroup < ActiveRecord::Migration
  def change
    add_column :business_groups, :business_group_type, :string
  end
end
