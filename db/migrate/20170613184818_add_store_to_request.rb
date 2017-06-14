class AddStoreToRequest < ActiveRecord::Migration
  def change
    add_reference :requests, :store, index: true, foreign_key: true
  end
end
