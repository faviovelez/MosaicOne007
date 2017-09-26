class RemoveFiscalResidencyFromBill < ActiveRecord::Migration
  def change
    remove_reference :bills, :fiscal_residency, index: true, foreign_key: true
  end
end
