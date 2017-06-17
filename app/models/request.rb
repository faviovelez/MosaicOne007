class Request < ActiveRecord::Base
  has_many :users, through: :request_users
  has_one :prospect
  has_many :documents
  has_many :modified_fields
  belongs_to :store
  has_many :design_requests
  has_one :order
  has_many :request_users
  has_one :role, through: :users
end
