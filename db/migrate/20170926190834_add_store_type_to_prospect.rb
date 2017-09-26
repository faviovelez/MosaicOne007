class AddStoreTypeToProspect < ActiveRecord::Migration
  def change
    add_reference :prospects, :store_type, index: true, foreign_key: true
  end
end
