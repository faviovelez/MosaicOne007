class ApiController < ApplicationController

  def get_all_products
    products =  Product.where(classification: 'de línea').where(current: true).where(parent: nil).has_inventory(
      params[:q]
    ).collect do |p|
      words = p.description.split(' ') [0..5]
      ["#{p.unique_code} #{words.join(' ')} #{p.exterior_color_or_design}", p.id ]
    end
    render json: { products: products }
  end

end
