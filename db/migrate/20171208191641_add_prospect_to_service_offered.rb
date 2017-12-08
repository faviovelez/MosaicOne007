class AddProspectToServiceOffered < ActiveRecord::Migration
  def change
    add_reference :service_offereds, :prospect, index: true, foreign_key: true
  end
end
