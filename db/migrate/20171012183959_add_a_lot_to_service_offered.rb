class AddALotToServiceOffered < ActiveRecord::Migration
  def change
    add_column :service_offereds, :initial_price, :float
    add_column :service_offereds, :automatic_discount, :float
    add_column :service_offereds, :manual_discount, :float
    add_column :service_offereds, :discount_applied, :float
    add_column :service_offereds, :rule_could_be, :boolean
    add_column :service_offereds, :final_price, :float
    add_column :service_offereds, :amount, :float
    add_column :service_offereds, :service_type, :string
    add_reference :service_offereds, :return_ticket, index: true, foreign_key: true
    add_reference :service_offereds, :change_ticket, index: true, foreign_key: true
    add_reference :service_offereds, :tax, index: true, foreign_key: true
    add_column :service_offereds, :taxes, :float
    add_column :service_offereds, :cost, :float
    add_reference :service_offereds, :ticket, index: true, foreign_key: true
  end
end
