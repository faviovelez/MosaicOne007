class DesignRequest < ActiveRecord::Base
  belongs_to :request
  has_many :documents
  belongs_to :user
end
