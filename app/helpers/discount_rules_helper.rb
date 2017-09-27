module DiscountRulesHelper

  def all_products
    Product.where.not(classification: 'especial').where(business_unit: current_user.store.business_unit.business_group.business_units).collect{ |p| [p.unique_code, p.id ] }
  end

  def select_products
    @products = []
    Product.all.collect{ |p| [p.unique_code, p.id] }.each do |o|
      @products << o
    end
    @products
  end

  def select_prospects
    @prospects = []
    Prospect.all.collect{ |p| [p.legal_or_business_name, p.id] }.each do |o|
      @prospects << o
    end
    @prospects
  end

end
