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

  def get_all_products_for_bill
    products =  Product.where(classification: 'de línea').where(current: true).where(child: nil)
    options = []
    products.each do |product|
      words = product.description.split(' ') [0..5]
      words_clean = words.join(' ')
      string = product.unique_code + ' ' + words_clean  + ' ' + product.exterior_color_or_design.to_s
      options << { "value" => string, "data" => product.id }
    end
    render json: { suggestions: options }
  end

#  def get_info_from_products
#    products =  Product.where(classification: 'de línea').where(current: true).where(child: nil)
#    product_wrapper = []
#    products.each do |product|
#      sat_key = product.sat_key.sat_key
#      unique_code = product.unique_code
#      sat_unit_key = product.sat_unit_key.unit
#      sat_unit_description = product.sat_unit_key.description
#      description = product.description
#      options << { "id" => product.id, "sat_key" => sat_key, "unique_code" => unique_code, "sat_unit_key" => sat_unit_key, "sat_unit_description" => sat_unit_description, "description" => description }
#    end
#    render json: { suggestions: product_wrapper }
#  end

  def get_prospects_for_store
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      prospects = current_user.store.prospects
    else
      prospects = Prospect.joins(:billing_address).joins(:business_unit).where(business_units: {name: 'Comercializadora de Cartón y Diseño'})
    end
    options = []
    prospects.each do |prospect|
      unless prospect.billing_address.nil?
        name = prospect.billing_address.business_name
        options << { "value" => name, "data" => prospect.id }
      end
    end
    render json: { suggestions: options }
  end

  def get_info_from_products
    product = Product.find(params[:product])
    if product.present?
      render json: {
                    product: product
                   }
    else
      render json: {product: false}
    end
  end

  def get_prospect_rfcs
    @prospects_rfcs = [['seleccione']]
    if (@user.role.name == 'store' || @user.role.name == 'store-admin')
      prospects = @store.prospects
    else
      prospects = Prospect.joins(:billing_address).joins(:business_unit).where(business_units: {name: 'Comercializadora de Cartón y Diseño'})
    end
  end

  def select_prospects_info
    prospect = Prospect.find(params[:prospect_id]).billing_address.rfc
    if prospect.present?
      render json: {
                    prospect: prospect
                   }
    else
      render json: {prospect: false}
    end
  end



end
