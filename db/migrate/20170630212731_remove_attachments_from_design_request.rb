class RemoveAttachmentsFromDesignRequest < ActiveRecord::Migration
  def change
    remove_column :design_requests, :attachments, :json
  end
end
