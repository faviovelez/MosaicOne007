class AddBillToServiceOffered < ActiveRecord::Migration
  def change
    add_reference :service_offereds, :bill, index: true, foreign_key: true
  end
end
