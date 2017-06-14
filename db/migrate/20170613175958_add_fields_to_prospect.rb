class AddFieldsToProspect < ActiveRecord::Migration
  def change
    add_column :prospects, :contact_first_name, :string
    add_column :prospects, :contact_middle_name, :string
    add_column :prospects, :contact_last_name, :string
    add_column :prospects, :contact_position, :string
    add_column :prospects, :direct_phone, :string
    add_column :prospects, :extension, :string
    add_column :prospects, :cell_phone, :string
    add_column :prospects, :business_type, :string
    add_column :prospects, :prospect_status, :string
    add_column :prospects, :discount, :float
  end
end
