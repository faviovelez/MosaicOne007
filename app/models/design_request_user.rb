class DesignRequestUser < ActiveRecord::Base
  # Para la tabla intermedia que relaciona design request y user (relación N a N).
  belongs_to :design_request
  belongs_to :user
end
