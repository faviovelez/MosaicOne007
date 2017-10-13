class RemoveBillFromServiceOffered < ActiveRecord::Migration
  def change
    remove_reference :service_offereds, :bill, index: true, foreign_key: true
  end
end
