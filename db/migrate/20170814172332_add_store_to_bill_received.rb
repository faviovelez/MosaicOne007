class AddStoreToBillReceived < ActiveRecord::Migration
  def change
    add_reference :bill_receiveds, :store, index: true, foreign_key: true
  end
end
