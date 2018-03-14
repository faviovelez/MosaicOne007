module ServicesHelper

  def get_service_sat_keys
    @sat_keys = []
    Service.find_each do |prod|
      @sat_keys << [prod.sat_key.sat_key, prod.sat_key.id] unless @sat_keys.include?([prod.sat_key.sat_key, prod.sat_key.id])
    end
    @sat_keys
  end

  def get_service_sat_unit_keys
    @sat_unit_keys = []
    Service.find_each do |prod|
      @sat_unit_keys << [prod.sat_unit_key.unit, prod.sat_unit_key.id] unless @sat_unit_keys.include?([prod.sat_unit_key.unit, prod.sat_unit_key.id])
    end
    @sat_unit_keys
  end

end
