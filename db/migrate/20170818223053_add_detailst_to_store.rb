class AddDetailstToStore < ActiveRecord::Migration
  def change
    add_column :stores, :contact_first_name, :string
    add_column :stores, :contact_middle_name, :string
    add_column :stores, :contact_last_name, :string
    add_column :stores, :direct_phone, :string
    add_column :stores, :extension, :string
    add_column :stores, :type_of_person, :string
    add_column :stores, :prospect_status, :string
    add_column :stores, :second_last_name, :string
    remove_column :stores, :phone, :string
    add_reference :stores, :business_group, index: true, foreign_key: true
  end
end
