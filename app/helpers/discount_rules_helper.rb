module DiscountRulesHelper

  def all_products
    Product.where.not(classification: 'especial').where(business_unit: current_user.store.business_unit.business_group.business_units).collect{ |p| [p.unique_code, p.id ] }
  end

end
