class RemoveReferencesFromServiceOffered < ActiveRecord::Migration
  def change
    remove_reference :service_offereds, :change_ticket, index: true, foreign_key: true
    remove_reference :service_offereds, :return_ticket, index: true, foreign_key: true
  end
end
