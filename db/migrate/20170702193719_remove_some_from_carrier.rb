class RemoveSomeFromCarrier < ActiveRecord::Migration
  def change
    remove_column :carriers, :street, :string
    remove_column :carriers, :exterior_number, :string
    remove_column :carriers, :interior_number, :string
    remove_column :carriers, :zipcode, :string
    remove_column :carriers, :neighborhood, :string
    remove_column :carriers, :additional_references, :text
    remove_reference :carriers, :order, index: true, foreign_key: true
  end
end
