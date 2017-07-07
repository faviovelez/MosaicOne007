class Request < ActiveRecord::Base
  has_many :users, through: :request_users
  belongs_to :prospect
  has_many :documents
  has_many :modified_fields
  belongs_to :store
  has_many :design_requests
  has_one :order
  has_many :request_users

  validate :outer_or_inner_fields, unless: :product_complete?

  private

  def outer_or_inner_fields
    outer_fields = [outer_length, outer_widht, outer_height]
    inner_fields = [inner_length, inner_width, inner_height]
    unless (outer_fields.all? || inner_fields.all?)
      errors[:base] << "Por favor llene todas las medidas o los detalles del producto."
    end
  end

  def product_complete?
    product_fields = [product_what, how_many, product_length, product_width, product_height]
    product_fields.all?
  end

end
