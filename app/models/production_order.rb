class ProductionOrder < ActiveRecord::Base
  belongs_to :user
  has_many :production_requests
end
