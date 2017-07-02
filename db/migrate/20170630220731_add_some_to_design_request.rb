class AddSomeToDesignRequest < ActiveRecord::Migration
  def change
    add_column :design_requests, :attachment, :string
  end
end
