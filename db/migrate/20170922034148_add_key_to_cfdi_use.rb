class AddKeyToCfdiUse < ActiveRecord::Migration
  def change
    add_column :cfdi_uses, :key, :string
  end
end
