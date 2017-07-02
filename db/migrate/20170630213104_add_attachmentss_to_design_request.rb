class AddAttachmentssToDesignRequest < ActiveRecord::Migration
  def change
    add_column :design_requests, :attachments, :string, array: true, default: []
  end
end
