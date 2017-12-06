class PosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def received_data
    if (check_login_data)
      @ids_references = {}
      tables_orders.each do |table_name|
        @ids_references[table_name.singularize] = {}
        params[:po][table_name].each do |key, values|
          next if invalid_params.include? key
          fill_references(table_name, key, values)
        end
      end
      render json: {status: "success", message: "Informacion Cargada"}
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

    def fill_references(table_name, pos_id, values)
      reg = create_reg(table_name, values)
      reg.save
      @ids_references[table_name.singularize][pos_id] = reg.id
    end

    def invalid_params
      %w(
        installCode storeId controller action rowsLimit processRow
      )
    end

    def create_reg(table_name, values)
      klass = table_name.singularize.camelize.constantize
      new_reg = klass.new
      values[:object].each do |attr|
        if is_relation_object(attr.first)
          id = vinculate_relations(attr.first, attr.last)
          new_reg.send("#{attr.first}=", id)
        else
          new_reg.send("#{attr.first}=", parsed_date(attr.last))
        end
      end
      add_extras(new_reg, table_name, values[:object])
      new_reg.id = klass.last.id + 1
      new_reg.web = true
      new_reg
    end

    def parsed_date(value)
      value.to_datetime - 6.hour
    rescue
      value
    end

    def is_relation_object(attribute)
      !!(attribute != 'store_id' && /_id/.match(attribute).present?)
    end

    def vinculate_relations(reference, value)
      table_name = reference.gsub(/_id/,'')
      object     = nil
      if @ids_references[table_name.singularize].nil?
        object = table_name.singularize.camelize.constantize.find(
          value
        )
        return object.id
      end
      @ids_references[table_name.singularize][value.to_s]
    rescue
      nil
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
      require 'bcrypt'
      code = BCrypt::Password.new(params[:installCode])
      !!(code == Store.find(params[:storeId]).install_code)
    rescue
      false
    end

end
