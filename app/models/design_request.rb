class DesignRequest < ActiveRecord::Base
  belongs_to :request
  has_many :documents
  has_many :design_request_users
  has_many :users, through: :design_request_users
end
