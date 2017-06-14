class AddFIeldsToDesignRequest < ActiveRecord::Migration
  def change
    add_column :design_requests, :description, :text
  end
end
