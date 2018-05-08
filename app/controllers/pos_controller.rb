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
      render json: {status: "error", message: "Error de acceso"}
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
        'stores_inventories',
        'service_offereds',
        'delivery_services',
        'expenses',
        'deposits',
        'withdrawals'
      ]
    end

    def params_find
      return {
        "StoresInventory" => ['product_id'],
        "BillingAddress" => ['business_name'],
        "Prospect" => ['legal_or_business_name'],
        "Terminal" => ['name'],
        "Ticket" => ['ticket_number', 'total'],
        "Payment" => ['ticket_id', 'total', 'payment_form_id', 'payment_number'],
        "StoreMovement" => ['product_id', 'quantity', 'web_id'],
        "ServiceOffered" => ['service_id', 'total', 'subtotal', 'quantity', 'taxes', 'ticket_id'],
        "DeliveryService" => ['service_offered_id', 'company'],
        "Deposit" => ['amount'],
        "withdrawal" => ['amount'],
        "Expense" => ['total']
      }
    end

    def changes_to_fields
      return {
        "CashRegister" => ['balance'],
        "BillingAddress" => ['type_of_person', 'business_name', 'rfc', 'street', 'exterior_number', 'interior_number', 'zipcode', 'neighborhood', 'city', 'state', 'country', 'tax_regime_id'],
        "Prospect" => ['legal_or_business_name', 'prospect_type', 'contact_first_name', 'contact_middle_name', 'contact_last_name', 'contact_position', 'direct_phone', 'extension', 'cell_phone', 'business_type', 'prospect_status', 'billing_address_id', 'delivery_address_id', 'second_last_name', 'email', 'credit_days'],
        "Terminal" => ['debit_comission', 'credit_comission'],
        "Ticket" => ['ticket_number', 'parent_id', 'ticket_type', 'cfdi_use', 'subtotal', 'total', 'taxes', 'discount_applied', 'prospect_id', 'comments', 'payed', 'cost', 'payments_amount', 'cash_return'],
        "StoresInventory" => ['quantity', 'manual_price', 'rack', 'level', 'manual_price_update', 'pos_id', 'web_id'],
        "Payment" => ['ticket_id', 'store_id', 'total', 'payment_form_id', 'payment_type', 'payment_number', 'credit_days'],
        "StoreMovement" => ['total', 'subtotal', 'taxes', 'cost', 'movement_type', 'total_cost'],
        "ServiceOffered" => ['total', 'subtotal', 'taxes', 'service_type', 'cost', 'total_cost'],
        "DeliveryService" => ['sender_name', 'sender_zipcode', 'tracking_number', 'receivers_name', 'contact_name', 'street', 'exterior_number', 'interior_number', 'city', 'neighborhood', 'state', 'country', 'phone', 'cellphone', 'service_offered_id'],
        "Deposit" => ['amount', 'name'],
        "Withdrawal" => ['amount', 'name'],
        "Expense" => ['total', 'subtotal', 'taxes', 'expense_type']
      }
    end

    def fill_references(table_name, pos_id, values)
      reg = create_reg(table_name, values)
      reg = is_a_new_register(reg)
      if reg.id.nil?
        reg.save
      end
      @ids_references[table_name.singularize][pos_id] = reg.id
    end

    def is_a_new_register(reg)
      tables_find_parameters = params_find()
      information = tables_find_parameters[reg.class.to_s] || []
      if (reg.class == StoresInventory || reg.class == CashRegister)
        information += ['store_id']
      else
        information += ['store_id', 'pos_id']
      end
      cad = ''
      information.each_with_index do |value, index|
        cad << "#{value} = '#{reg.send(value)}'"
        cad.gsub!("web_id = ''", "") if cad.include?("web_id = ''")
        cad << " AND " unless index == information.length - 1
      end
      cad.gsub!("AND  AND", "AND")
      object = reg.class.where(cad).first
      return reg if object.nil?
      updated_reg_for(object, reg)
      return object
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

    def set_store_id(value, reference)
      @store_id = value if reference == 'store_id'
    end

    def create_reg(table_name, values)
      klass = table_name.singularize.camelize.constantize
      new_reg = klass.new
      values[:object].each do |attr|
        set_store_id(attr.last, attr.first) if @store_id.nil?
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
      table_name = 'ticket' if table_name == 'parent' || table_name == 'children'
      if @ids_references[table_name.singularize][value.to_s].nil?
        return table_name.camelcase.constantize.where(
          store_id: @store_id).find_by_pos_id(
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
