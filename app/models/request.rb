class Request < ActiveRecord::Base
  has_one :prospect
  has_many :documents
  has_many :modified_fields
  belongs_to :store
  has_one :user
  has_many :design_requests
end
