class PosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def received_data
    if (check_login_data) || true
      @ids_references = {}
      tables_orders.each do |table_name|
        @ids_references[table_name.singularize] = {}
        params[table_name].each do |key, values|
          next if invalid_params.include? key
          fill_references(table_name, key, values)
        end
      end
      render json: {status: "success", message: "Informacion Cargada", ids: @ids_references}
    else
      render json: {status: "error", message: "Login Error"}
    end
  end

  private

    def tables_orders
      [
        'users',
        'billing_addresses',
        'prospects',
        'cash_registers',
        'tickets',
        'tickets_children',
        'terminals',
        'payments',
        'store_movements',
        'stores_warehouse_entries',
        'stores_inventories',
        'service_offereds',
        'delivery_services',
        'expenses'
      ]
    end

    def params_find
      return {
        "CashRegister" => ['store_id'],
        "StoresInventory" => ['store_id', 'product_id'],
        "BillingAddress" => ['business_name'],
        "Prospect" => ['legal_or_business_name'],
        "Terminal" => ['store_id', 'name']
      }
    end

    def changes_to_fields
      return {
        "CashRegister" => ['balance'],
        "StoresInventory" => ['manual_price_update', 'manual_price', 'quantity'],
        "BillingAddress" => ['type_of_person', 'business_name', 'rfc', 'street', 'exterior_number', 'interior_number', 'zipcode', 'neighborhood', 'city', 'state', 'country', 'tax_regime_id'],
        "Prospect" => ['legal_or_business_name', 'prospect_type', 'contact_first_name', 'contact_middle_name', 'contact_last_name', 'contact_position', 'direct_phone', 'extension', 'cell_phone', 'business_type', 'prospect_status', 'billing_address_id', 'delivery_address_id', 'second_last_name', 'email', 'credit_days'],
        "Terminal" => ['debit_comission', 'credit_comission']
      }
    end

    def fill_references(table_name, pos_id, values)
      reg = create_reg(table_name, values)
      reg = is_a_new_register(reg)
      if reg.id.nil?
        reg.save
      end
      debugger if values["object"]["user_id"].present?
      @ids_references[table_name.singularize][pos_id] = reg.id
    end

    def is_a_new_register(reg)
      tables_find_parameters = params_find()
      info = tables_find_parameters[reg.class.to_s]
      if info.present?
        cad = ''
        info.each_with_index do |value, index|
          cad << "#{value} = '#{reg.send(value)}'"
          cad << "AND " unless index == info.length - 1
        end
        object = reg.class.where(cad).first
        return reg if object.nil?
        updated_reg_for(object, reg)
        return object
      end
      reg
    end

    def updated_reg_for(object, reg)
      updated_parameters = changes_to_fields()[reg.class.to_s]
      if updated_parameters.present?
        hash = {}
        updated_parameters.each do |parameter|
          hash["#{parameter}"] = reg.send(parameter)
        end
        object.update_attributes(hash)
      end
      return false
    end

    def invalid_params
      %w(
        installCode storeId controller action rowsLimit processRow
      )
    end

    # Probablemente tengamos que modificar este método
    def create_reg(table_name, values)
      klass = table_name.singularize.camelize.constantize
      new_reg = klass.new
      values[:object].each do |attr|
        next if %w(pos_id web_id).include?(attr.first)
        if is_relation_object(attr.first)
          id = vinculate_relations(attr.first, attr.last)
          new_reg.send("#{attr.first}=", id)
        elsif datetime_fields.include? attr.first
          new_reg.send("#{attr.first}=", parsed_date(attr.last))
        else
          new_reg.send("#{attr.first}=", attr.last)
        end
      end
      add_extras(new_reg, table_name, values[:object])
      new_reg.web = true
      new_reg
    end

    def parsed_date(value)
      value.to_datetime - 6.hour
    rescue
      value
    end

    def datetime_fields
      %(
        created_at
        updated_at
        date
      )
    end

    def is_relation_object(attribute)
      !!(attribute != 'store_id' && /_id/.match(attribute).present?)
    end

    def vinculate_relations(reference, value)
      return nil if value.nil?
      table_name = reference.gsub(/_id/,'')
      object     = nil
      if @ids_references[table_name.singularize][value.to_s].nil?
        return table_name.camelcase.constantize.find_by_pos_id(
          value
        ).web_id
      end
      @ids_references[table_name.singularize][value.to_s]
    rescue
      value
    end

    def add_extras(reg, table_name, values)
      case table_name
      when 'users'
        reg.password              = values[:encrypted_password]
        reg.password_confirmation = values[:encrypted_password]
      end
    end

    def can_process?(table_name)
      !!(invalid_params.include? table_name ||
        params[:po][table_name][:rowsLimit] === 0)
    end

    def check_login_data
      code = params[:installCode]
      !!(code == Store.find(params[:storeId]).install_code)
    rescue
      false
    end

end
