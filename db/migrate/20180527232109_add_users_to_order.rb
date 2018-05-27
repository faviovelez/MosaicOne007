class AddUsersToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :request_user, index: true
    add_reference :orders, :confirm_user, index: true
  end
end
