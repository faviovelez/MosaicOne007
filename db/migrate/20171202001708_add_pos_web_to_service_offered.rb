class AddPosWebToServiceOffered < ActiveRecord::Migration
  def change
    add_column :service_offereds, :pos, :boolean, default: false
    add_column :service_offereds, :web, :boolean, default: true
    add_column :service_offereds, :date, :date
  end
end
