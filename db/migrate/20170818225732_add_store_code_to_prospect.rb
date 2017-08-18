class AddStoreCodeToProspect < ActiveRecord::Migration
  def change
    add_column :prospects, :store_code, :string
  end
end
