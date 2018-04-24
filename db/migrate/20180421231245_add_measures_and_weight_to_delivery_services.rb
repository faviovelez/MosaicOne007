class AddMeasuresAndWeightToDeliveryServices < ActiveRecord::Migration
  def change
    add_column :delivery_services, :weight, :string
    add_column :delivery_services, :height, :string
    add_column :delivery_services, :length, :string
    add_column :delivery_services, :width, :string
  end
end
