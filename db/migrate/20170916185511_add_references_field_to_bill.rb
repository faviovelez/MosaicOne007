class AddReferencesFieldToBill < ActiveRecord::Migration
  def change
    add_column :bills, :references_field, :string
  end
end
