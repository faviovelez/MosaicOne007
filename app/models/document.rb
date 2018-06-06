class Document < ActiveRecord::Base
  # Para todos los documentos de request y design request, quizás lo use también para las facturas.
  belongs_to :request
  belongs_to :design_request
  belongs_to :bill
  mount_uploader :document, DocumentUploader
end
