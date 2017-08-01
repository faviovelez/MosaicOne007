class AddSecondTypeToStore < ActiveRecord::Migration
  def change
    add_reference :stores, :store_type, index: true, foreign_key: true
  end
end
