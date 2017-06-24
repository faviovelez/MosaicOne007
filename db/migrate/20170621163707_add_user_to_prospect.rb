class AddUserToProspect < ActiveRecord::Migration
  def change
    add_reference :prospects, :user, index: true, foreign_key: true
  end
end
