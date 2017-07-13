class AddNotesToDesignRequest < ActiveRecord::Migration
  def change
    add_column :design_requests, :notes, :text
  end
end
