class Prospect < ActiveRecord::Base
  belongs_to :store
  has_many :requests
end
