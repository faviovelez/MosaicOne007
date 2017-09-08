class AddStoreToBill < ActiveRecord::Migration
  def change
    add_reference :bills, :store, index: true, foreign_key: true
  end
end
