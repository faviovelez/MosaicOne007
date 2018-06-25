module DeliveryServicesHelper

  def company_options
    options = [['Todas']]
    Service.where.not(delivery_company:nil).distinct.pluck(:delivery_company).each do |company|
      options << [company]
    end
    @options = options
  end

end
