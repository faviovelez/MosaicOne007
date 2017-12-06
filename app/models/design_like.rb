class DesignLike < ActiveRecord::Base
  has_many :materials, through: :materials_design_likes
  has_many :materials_design_likes
end
