class AddBusinessGroupToProspect < ActiveRecord::Migration
  def change
    add_reference :prospects, :business_group, index: true, foreign_key: true
  end
end
