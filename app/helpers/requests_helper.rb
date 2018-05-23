module RequestsHelper

  def secondary_material_options
    options = [['seleccione', '']]
    Material.find_each do |m|
      if (m.name == 'papel kraft' || m.name == 'papel bond')
        options << [m.name, class: 'resistance secondary bolsa']
      elsif (m.name == 'celofán' || m.name == 'acetato')
        options << [m.name, class: 'resistance secondary']
      else
        options << [m.name, class: 'resistance secondary caja']
      end
    end
    options << ['sugerir material']
    options
  end

  def third_material_options
    options = [['seleccione', '']]
    Material.find_each do |m|
      if (m.name == 'papel kraft' || m.name == 'papel bond')
        options << [m.name, class: 'resistance third bolsa']
      elsif (m.name == 'celofán' || m.name == 'acetato')
        options << [m.name, class: 'resistance third']
      else
        options << [m.name, class: 'resistance third caja']
      end
    end
    options << ['sugerir material']
    options
  end

  def secondary_resistance_options
    options = [['seleccione', '']]
    r_plegadizo = Resistance.where("name LIKE ?", "%pts%")
    r_liner = Resistance.where("name LIKE ?", "%grs%")
    r_corrugado = Resistance.where("name LIKE ? AND name NOT LIKE ?", "%ECT%", "%DC%")
    r_d_corrugado = Resistance.where("name LIKE ? AND name LIKE ?", "%ECT%", "%DC%")

    r_plegadizo.find_each do |r|
      options << [r.name, class: 'secondary plegadizo hidden']
    end
    r_liner.find_each do |r|
      options << [r.name, class: 'secondary liner hidden']
    end
    r_corrugado.find_each do |r|
      options << [r.name, class: 'secondary corrugado hidden']
    end
    r_d_corrugado.find_each do |r|
      options << [r.name, class: 'secondary doble_corrugado hidden']
    end
    options << ['no aplica', class: 'secondary otros hidden']
    options << ['sugerir resistencia']
    options
  end

  def third_resistance_options
    options = [['seleccione', '']]
    r_plegadizo = Resistance.where("name LIKE ?", "%pts%")
    r_liner = Resistance.where("name LIKE ?", "%grs%")
    r_corrugado = Resistance.where("name LIKE ? AND name NOT LIKE ?", "%ECT%", "%DC%")
    r_d_corrugado = Resistance.where("name LIKE ? AND name LIKE ?", "%ECT%", "%DC%")

    r_plegadizo.find_each do |r|
      options << [r.name, class: 'third plegadizo hidden']
    end
    r_liner.find_each do |r|
      options << [r.name, class: 'third liner hidden']
    end
    r_corrugado.find_each do |r|
      options << [r.name, class: 'third corrugado hidden']
    end
    r_d_corrugado.find_each do |r|
      options << [r.name, class: 'third doble_corrugado hidden']
    end
    options << ['no aplica', class: 'third otros hidden']
    options << ['sugerir resistencia']
    options
  end

  def finishing_options
    options = [['Seleccione', ''], ['Sin acabados']]
    Finishing.find_each do |f|
      options << [f.name]
    end
    options
  end

end
