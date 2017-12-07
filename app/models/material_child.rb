class MaterialChild < ActiveRecord::Base
  belongs_to :material
  belongs_to :children, class_name: 'Material', foreign_key: 'children_id'
end
