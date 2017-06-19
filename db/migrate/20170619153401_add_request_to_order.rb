class AddRequestToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :request, index: true, foreign_key: true
  end
end
