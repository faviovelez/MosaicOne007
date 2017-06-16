class Request < ActiveRecord::Base
  belongs_to :user
  has_one :prospect
  has_many :documents
  has_many :modified_fields
  belongs_to :store
  has_many :design_requests
end
