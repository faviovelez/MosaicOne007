class AddEstimateDocToRequest < ActiveRecord::Migration
  def change
    add_reference :requests, :estimate_doc, index: true, foreign_key: true
  end
end
