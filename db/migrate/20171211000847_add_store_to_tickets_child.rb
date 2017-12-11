class AddStoreToTicketsChild < ActiveRecord::Migration
  def change
    add_reference :tickets_children, :store, index: true, foreign_key: true
  end
end
