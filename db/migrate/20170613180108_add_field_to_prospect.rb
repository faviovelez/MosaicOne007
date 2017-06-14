class AddFieldToProspect < ActiveRecord::Migration
  def change
    add_column :prospects, :legal_or_business_name, :string
  end
end
