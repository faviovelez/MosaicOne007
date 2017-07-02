class RemoveAttachmentFromDesignRequest < ActiveRecord::Migration
  def change
    remove_column :design_requests, :attachment, :string
  end
end
