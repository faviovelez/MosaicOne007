class AddBusinessGroupToSupplier < ActiveRecord::Migration
  def change
    add_reference :suppliers, :business_group, index: true, foreign_key: true
  end
end
