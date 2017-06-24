class AddGroupToStore < ActiveRecord::Migration
  def change
    add_reference :stores, :group, index: true, foreign_key: true
  end
end
