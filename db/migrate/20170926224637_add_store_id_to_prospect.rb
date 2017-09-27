class AddStoreIdToProspect < ActiveRecord::Migration
  def change
    add_reference :prospects, :store_prospect, index: true
  end
end
