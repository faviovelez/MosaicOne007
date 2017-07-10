class AddColumnToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :specification_document, :boolean
  end
end
