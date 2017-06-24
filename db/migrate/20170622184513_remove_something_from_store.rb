class RemoveSomethingFromStore < ActiveRecord::Migration
  def change
    remove_reference :stores, :group, index: true, foreign_key: true
  end
end
