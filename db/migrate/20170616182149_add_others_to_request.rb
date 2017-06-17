class AddOthersToRequest < ActiveRecord::Migration
  def change
    add_reference :requests, :manager, index: true, foreign_key: true
    add_reference :requests, :designer, index: true, foreign_key: true
  end
end
