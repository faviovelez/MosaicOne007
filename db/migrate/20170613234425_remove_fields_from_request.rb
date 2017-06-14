class RemoveFieldsFromRequest < ActiveRecord::Migration
  def change
    remove_column :requests, :require_dummy, :boolean
    remove_column :requests, :require_printcard, :boolean
    remove_column :requests, :printcard_authorised, :boolean
    remove_column :requests, :dummy_generated, :boolean
    remove_column :requests, :dummy_authorised, :boolean
    remove_column :requests, :printcard_generated, :boolean
    remove_column :requests, :dummy_cost, :float
    remove_column :requests, :design_cost, :float
  end
end
