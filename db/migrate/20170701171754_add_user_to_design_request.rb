class AddUserToDesignRequest < ActiveRecord::Migration
  def change
    add_reference :design_requests, :user, index: true, foreign_key: true
  end
end
