class RemoveUserFromDesignRequest < ActiveRecord::Migration
  def change
    remove_reference :design_requests, :user, index: true, foreign_key: true
  end
end
