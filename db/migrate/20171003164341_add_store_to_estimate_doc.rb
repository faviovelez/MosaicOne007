class AddStoreToEstimateDoc < ActiveRecord::Migration
  def change
    add_reference :estimate_docs, :store, index: true, foreign_key: true
  end
end
