class AddMeasuresToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :what_measures, :string
  end
end
