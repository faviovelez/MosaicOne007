class RemoveAttachmentssFromDesignRequest < ActiveRecord::Migration
  def change
    remove_column :design_requests, :attachments, :string
  end
end
