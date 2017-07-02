class AddSomeToCarrier < ActiveRecord::Migration
  def change
    add_reference :carriers, :delivery_address, index: true, foreign_key: true
  end
end
