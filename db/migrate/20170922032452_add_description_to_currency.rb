class AddDescriptionToCurrency < ActiveRecord::Migration
  def change
    add_column :currencies, :description, :string
    add_column :currencies, :decimals, :integer
  end
end
