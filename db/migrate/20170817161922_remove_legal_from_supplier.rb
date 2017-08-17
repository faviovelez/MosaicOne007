class RemoveLegalFromSupplier < ActiveRecord::Migration
  def change
    remove_column :suppliers, :legal_or_business_name, :string
  end
end
