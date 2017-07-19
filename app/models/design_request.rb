class DesignRequest < ActiveRecord::Base
  # Todo lo relacionado con design requests.
  belongs_to :request
  has_many :documents
  has_many :users, through: :design_request_users
  has_many :design_request_users
end
