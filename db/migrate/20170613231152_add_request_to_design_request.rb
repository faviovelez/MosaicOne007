class AddRequestToDesignRequest < ActiveRecord::Migration
  def change
    add_reference :design_requests, :request, index: true, foreign_key: true
  end
end
