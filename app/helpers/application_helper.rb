module ApplicationHelper

  def find_manager(request, role = 'manager' || role = 'director')
    user_id = 0
    request.users.each do |user_in_request|
      if (user_in_request.role.name == role)
        user_id = user_in_request.id
      end
    end
    @follower = request.users.find(user_id)
  end

  def find_designer(request, role = 'designer')
    user_id = 0
    request.users.each do |user_in_request|
      if (user_in_request.role.name == role)
        user_id = user_in_request.id
      end
    end
    @follower = request.users.find(user_id)
  end

  def value_of_product_type(request)
    if request.product_type == 'otro'
      @value = request.name_type
    else
      @value = request.product_type
    end
    @value
  end

  def sum_quantity(requests)
    @result = 0
    requests.each do |r|
      @result += r.quantity
    end
    @result
  end

# Inicia la sección de métodos utilizados por formularios en Products y Requests
  def product_line_options
    options = [['seleccione', '']]
    Classification.all.each do |c|
      options << [c.name]
    end
    options
  end

  def product_type_options
    options = [['seleccione', '']]
    ProductType.all.each do |t|
      if t.product_type == 'caja'
        options << [t.product_type, class: 'box-other']
      else
        options << [t.product_type]
      end
    end
    options << ['otro', class: 'box-other']
    options
  end

  def interior_color_options
    options = []
    InteriorColor.all.each do |i|
      options << [i.name]
    end
    options
  end

  def exterior_color_options
    options = []
    ExteriorColor.all.each do |e|
      options << [e.name]
    end
    options
  end

  def main_material_options
    options = [['seleccione', '']]
    Material.all.each do |m|
      unless (m.name == 'papel arroz' || m.name == 'celofán' || m.name == 'acetato')
        if (m.name == 'papel kraft' || m.name == 'papel bond')
          options << [m.name, class: 'resistance main bolsa']
        else
          options << [m.name, class: 'resistance main caja']
        end
      end
    end
    options << ['sugerir material']
    options
  end

  def main_resistance_options
    options = [['seleccione', '']]
    r_plegadizo = Resistance.where("name LIKE ?", "%pts%")
    r_liner = Resistance.where("name LIKE ?", "%grs%")
    r_corrugado = Resistance.where("name LIKE ? AND name NOT LIKE ?", "%ECT%", "%DC%")
    r_d_corrugado = Resistance.where("name LIKE ? AND name LIKE ?", "%ECT%", "%DC%")

    r_plegadizo.all.each do |r|
      options << [r.name, class: 'main plegadizo hidden']
    end
    r_liner.all.each do |r|
      options << [r.name, class: 'main liner hidden']
    end
    r_corrugado.all.each do |r|
      options << [r.name, class: 'main corrugado hidden']
    end
    r_d_corrugado.all.each do |r|
      options << [r.name, class: 'main doble_corrugado hidden']
    end
    options << ['no aplica', class: 'main otros hidden']
    options << ['sugerir resistencia']
    options
  end

  def design_options
    options = [['Seleccione', '']]
    DesignLike.all.each do |d|
      options << [d.name]
    end
    options << ['Sugerir armado']
    options
  end
# Termina la sección de métodos utilizados por formularios en Products y Requests

end
