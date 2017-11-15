class AddUuidToBill < ActiveRecord::Migration
  def change
    add_column :bills, :uuid, :string
  end
end
