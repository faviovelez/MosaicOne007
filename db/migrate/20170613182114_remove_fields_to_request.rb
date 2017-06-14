class RemoveFieldsToRequest < ActiveRecord::Migration
  def change
    remove_reference :requests, :user, index: true, foreign_key: true
  end
end
