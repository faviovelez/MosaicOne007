class AddZipCodeToStore < ActiveRecord::Migration
  def change
    add_column :stores, :zip_code, :string
  end
end
