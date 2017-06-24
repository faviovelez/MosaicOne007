class RemoveUserFromProspect < ActiveRecord::Migration
  def change
    remove_reference :prospects, :user, index: true, foreign_key: true
  end
end
