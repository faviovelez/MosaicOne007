class RequestUser < ActiveRecord::Base
  # Para la tabla intermedia que relaciona request y user (relación N a N).
  belongs_to :request
  belongs_to :user
end
