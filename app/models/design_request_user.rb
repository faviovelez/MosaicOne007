class DesignRequestUser < ActiveRecord::Base
  belongs_to :design_request
  belongs_to :user
end
