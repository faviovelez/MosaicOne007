class RemoveTypeFromProspect < ActiveRecord::Migration
  def change
    remove_column :prospects, :type, :string
  end
end
