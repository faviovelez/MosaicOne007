class AddProspectTypeToProspect < ActiveRecord::Migration
  def change
    add_column :prospects, :prospect_type, :string
  end
end
