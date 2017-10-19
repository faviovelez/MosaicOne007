class TemporalNumber < ActiveRecord::Base
  belongs_to :store
  belongs_to :business_group
end
