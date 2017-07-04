class AddProductToBill < ActiveRecord::Migration
  def change
    add_reference :bills, :product, index: true, foreign_key: true
  end
end
