class AddColumnsToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :product_code, :string
    add_column :requests, :final_quantity, :integer
    add_column :requests, :require_dummy, :boolean
    add_column :requests, :require_printcard, :boolean
    add_column :requests, :printcard_authorised, :boolean
    add_column :requests, :dummy_generated, :boolean
    add_column :requests, :dummy_authorised, :boolean
    add_column :requests, :printcard_generated, :boolean
    add_column :requests, :payment_uploaded, :boolean
    add_column :requests, :authorisation_signed, :boolean
    add_column :requests, :date_finished, :date
    add_column :requests, :internal_cost, :float
    add_column :requests, :internal_price, :float
    add_column :requests, :sales_price, :float
    add_column :requests, :impression_type, :string
    add_column :requests, :impression_where, :string
    add_column :requests, :dummy_cost, :float
    add_column :requests, :design_cost, :float
    add_column :requests, :design_like, :string
    add_column :requests, :resistance_like, :string
    add_column :requests, :rigid_color, :string
    add_column :requests, :paper_type_rigid, :string
    add_column :requests, :main_material_color, :string
    add_column :requests, :secondary_material_color, :string
    add_column :requests, :third_material_color, :string
  end
end
