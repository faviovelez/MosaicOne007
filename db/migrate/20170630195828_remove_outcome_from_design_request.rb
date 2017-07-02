class RemoveOutcomeFromDesignRequest < ActiveRecord::Migration
  def change
    remove_column :design_requests, :outcome, :string
  end
end
