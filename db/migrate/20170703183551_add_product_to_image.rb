class AddProductToImage < ActiveRecord::Migration
  def change
    add_reference :images, :product, index: true, foreign_key: true
  end
end
