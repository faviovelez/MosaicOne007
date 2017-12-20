class ApiController < ApplicationController

  def get_all_products
    products =  Product.where(classification: 'de línea').where(current: true).where(child: nil).has_inventory(
      params[:q]
    ).collect do |p|
      words = p.description.split(' ') [0..5]
      ["#{p.unique_code} #{words.join(' ')} #{p.exterior_color_or_design}", p.id ]
    end
    render json: { products: products }
  end

#  def get_all_products_for_bill
#    products =  Product.where(classification: 'de línea').where(current: true).where(child: nil)
#    options = []
#    products.each do |product|
#      words = product.description.split(' ') [0..5]
#      words_clean = words.join(' ')
#      string = product.unique_code + ' ' + words_clean  + ' ' + product.exterior_color_or_design.to_s
#      options << { "value" => string, "data" => product.id }
#    end
#    render json: { suggestions: options }
#  end

#  def get_all_products_for_bill
#    options = []
#    products =  Product.where(classification: 'de línea').where(current: true).where(child: nil).collect do |p|
#      words = p.description.split(' ') [0..5]
#      words_clean = words.join(' ')
#      string = p.unique_code + ' ' + words_clean  + ' ' + p.exterior_color_or_design.to_s
#      options << { "value" => string, "data" => product.id }
#    end
#    render json: { suggestions: options }
#  end


end
