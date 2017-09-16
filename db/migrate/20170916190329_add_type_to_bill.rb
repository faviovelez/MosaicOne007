class AddTypeToBill < ActiveRecord::Migration
  def change
    add_reference :bills, :type_of_bill, index: true, foreign_key: true
  end
end
