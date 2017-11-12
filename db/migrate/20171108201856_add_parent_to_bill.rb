class AddParentToBill < ActiveRecord::Migration
  def change
    add_reference :bills, :parent, index: true
  end
end
