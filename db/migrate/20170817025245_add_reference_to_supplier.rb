class AddReferenceToSupplier < ActiveRecord::Migration
  def change
    add_reference :suppliers, :business_unit, index: true, foreign_key: true
    add_reference :suppliers, :store, index: true, foreign_key: true
  end
end
