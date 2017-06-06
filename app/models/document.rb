class Document < ActiveRecord::Base
  belongs_to :request
  mount_uploader :document, DocumentUploader
end
