class Request < ActiveRecord::Base
  belongs_to :prospect
  has_many :documents
end
