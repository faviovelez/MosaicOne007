class AddContraToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :contraencolado, :boolean
  end
end
