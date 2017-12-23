module BillingAddressesHelper

  def tax_regime_options
    @tax_regime_options = []
    TaxRegime.find_each do |regime|
      @tax_regime_options << [regime.description, regime.id]
    end
    @tax_regime_options
  end

end
