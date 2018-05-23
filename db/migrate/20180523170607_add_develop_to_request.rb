class AddDevelopToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :develop, :text
  end
end
