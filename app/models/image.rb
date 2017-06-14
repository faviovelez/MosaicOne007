class Image < ActiveRecord::Base
  belongs_to :product_catalog
  mount_uploader :image, ImageUploader
end
