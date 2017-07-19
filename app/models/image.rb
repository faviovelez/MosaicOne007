class Image < ActiveRecord::Base
  # Aún no lo utilizo pero será para las imágenes del catálogo en el modelo Product
  belongs_to :product
  mount_uploader :image, ImageUploader
end
