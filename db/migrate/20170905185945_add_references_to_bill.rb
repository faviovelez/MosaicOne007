class AddReferencesToBill < ActiveRecord::Migration
  def change
    add_reference :bills, :issuing_company, index: true
    add_reference :bills, :receiving_company, index: true
  end
end
