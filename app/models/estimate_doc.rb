class EstimateDoc < ActiveRecord::Base
  belongs_to :prospect
  belongs_to :store
  belongs_to :user
  has_many :estimates
  has_many :requests
end
