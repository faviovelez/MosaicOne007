class Finishing < ActiveRecord::Base
  has_many :materials, through: :materials_finishings
  has_many :materials_finishings
end
