class Document < ActiveRecord::Base
  belongs_to :request
  belongs_to :design_request
  mount_uploader :document, DocumentUploader
end
