class AddManyToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :how_many, :string
  end
end
