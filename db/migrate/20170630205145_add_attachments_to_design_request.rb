class AddAttachmentsToDesignRequest < ActiveRecord::Migration
  def change
    add_column :design_requests, :attachments, :json
  end
end
