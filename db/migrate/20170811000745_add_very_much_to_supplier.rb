class AddVeryMuchToSupplier < ActiveRecord::Migration
  def change
    add_column :suppliers, :legal_or_business_name, :string
    add_column :suppliers, :type_of_person, :string
    add_column :suppliers, :contact_first_name, :string
    add_column :suppliers, :contact_middle_name, :string
    add_column :suppliers, :contact_last_name, :string
    add_column :suppliers, :contact_position, :string
    add_column :suppliers, :direct_phone, :string
    add_column :suppliers, :extension, :string
    add_column :suppliers, :cell_phone, :string
    add_column :suppliers, :email, :string
    add_column :suppliers, :supplier_status, :string
    add_reference :suppliers, :delivery_address, index: true, foreign_key: true
  end
end
