class ProductCatalog < ActiveRecord::Base
  has_many :orders
  has_many :images

end
