class AddContactToStore < ActiveRecord::Migration
  def change
    add_column :stores, :phone, :integer
    add_column :stores, :cellphone, :integer
    add_column :stores, :email, :string
  end
end
