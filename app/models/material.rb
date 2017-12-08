class Material < ActiveRecord::Base
  has_many :resistances, through: :materials_resistances
  has_many :materials_resistances
  has_many :interior_colors
  has_many :exterior_colors
  has_many :finishings, through: :materials_finishings
  has_many :materials_finishings
  has_many :design_likes, through: :materials_design_likes
  has_many :materials_design_likes
  has_many :design_likes, through: :materials_design_likes
  has_many :materials_design_likes
  has_many :exterior_colors, through: :materials_exterior_colors
  has_many :materials_exterior_colors
  has_many :interior_colors, through: :materials_interior_colors
  has_many :materials_interior_colors
  has_many :impression_types, through: :materials_impression_types
  has_many :materials_impression_types
  belongs_to :parent, class_name: 'Material', foreign_key: 'parent_id'
  has_many :children, through: :material_children, foreign_key: 'children_id'
  has_many :material_children
end
