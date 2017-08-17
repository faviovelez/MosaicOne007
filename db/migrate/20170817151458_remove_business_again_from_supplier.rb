class RemoveBusinessAgainFromSupplier < ActiveRecord::Migration
  def change
    remove_reference :suppliers, :business_unit, index: true, foreign_key: true
  end
end
