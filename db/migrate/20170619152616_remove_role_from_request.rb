class RemoveRoleFromRequest < ActiveRecord::Migration
  def change
    remove_reference :requests, :manager, index: true, foreign_key: true
    remove_reference :requests, :designer, index: true, foreign_key: true
  end
end
