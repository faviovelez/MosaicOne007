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
      process_incomming_data # Cambiar después a un background job
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

    ### ESTA SECCIÓN DEBE IR A UN BACKGROUND JOB ###
    def process_incomming_data
      # Confirmar si va a entrar tienda por tienda
      @tickets = Ticket.where(saved: [nil, false])
      store = @tickets.first.store
      @tickets.each do |ticket|
        ticket.store_movements.each do |mov|
          @mov = mov
          validate_if_summary_exists(@mov)
        end
        ticket.service_offereds.each do |serv|
          @mov = serv
          validate_if_summary_exists(@mov)
        end
        ticket.payments.each do |pay|
          unless pay.payment_form.description == 'Por definir'
            @pay = pay
            if store_sale(@pay) == nil
              create_only_payments(@pay)
            else
              update_only_payments(@pay, store_sale(@pay))
            end
          end
        end
        ticket.update(saved: true) # pos: false ?? Validar si puede actualizarse en 2 vías
      end
      store.stores_inventories.each do |inventory|
        process_store_inventories(inventory)
      end
    end

    def process_store_inventories(inventory)
      # Usar una lógica similar para inventories (de diseños de cartón)
      get_desired_inventory(inventory)
      change_alert(inventory, @actual_stock, @desired_inventory, @reorder_quantity, @critical_quantity)
      send_mail_to_alert(inventory)
    end

    def get_desired_inventory(inventory)
      product = inventory.product
      store = inventory.store
      months = store.months_in_inventory
      date = Date.today
      reorder = store.reorder_point / 100
      critical = store.critical_point / 100
      @actual_stock = inventory.quantity

      @desired_inventory = 0
      for i in 1..months
        quantity = ProductSale.where(
          product: product,
          store: store,
          month: date.month,
          year: date.year
        ).quantity
        @desired_inventory += quantity
        date -= 1.month
      end
      @desired_inventory
      @reorder_quantity = (@desired_inventory * reorder).to_i
      @critical_quantity = (@desired_inventory * critical).to_i
    end

    def change_alert(inventory, stock, desired, reorder, critical)
      @alert = false
      if (stock <= reorder && stock > critical)
        alert_changed_to_true(inventory)
        inventory.update(alert: true, alert_type: 'bajo')
      elsif stock <= critical
        alert_changed_to_true(inventory)
        inventory.update(alert: true, alert_type: 'crítico')
      else
        inventory.update(alert: false, alert_type: nil)
      end
    end

    def alert_changed_to_true(inventory)
      @changed = false
      if inventory.alert == false
        @changed = true
      end
      @changed
    end

    def send_mail_to_alert(inventory)
      # if @changed == true
    end

    def validate_if_summary_exists(mov)
      if mov.is_a?(StoreMovement)
        if product_sale(mov) == nil
          create_product_sale(mov)
        else
          update_product_sale(mov, product_sale(mov))
        end
      else
        if service_sale(mov) == nil
          create_service_sale(mov)
        else
          update_service_sale(mov, service_sale(mov))
        end
      end

      unless mov.ticket.prospect == nil
        if prospect_sale(mov) == nil
          create_prospect_sale(mov)
        else
          update_prospect_sale(mov, prospect_sale(mov))
        end
      end

      if store_sale(mov) == nil
        create_store_sale(mov)
      else
        update_store_sale(mov, store_sale(mov))
      end

      if business_unit_sale(mov) == nil
        create_business_unit_sale(mov)
      else
        update_business_unit_sale(mov, business_unit_sale(mov))
      end

      if business_group_sale(mov) == nil
        create_business_group_sale(mov)
      else
        update_business_group_sale(mov, business_group_sale(mov))
      end
    end

    def business_unit_sale(mov)
      BusinessUnitSale.where(month: mov.created_at.month, year: mov.created_at.year, business_unit: mov.store.business_unit).first
    end

    def business_group_sale(mov)
      BusinessGroupSale.where(month: mov.created_at.month, year: mov.created_at.year, business_group: mov.store.business_unit.business_group).first
    end

    def prospect_sale(mov)
      ProspectSale.where(month: mov.created_at.month, year: mov.created_at.year, store: mov.store, prospect: mov.ticket.prospect).first
    end

    def product_sale(mov)
      ProductSale.where(month: mov.created_at.month, year: mov.created_at.year, store: mov.store, product: mov.product).first
    end

    def service_sale(mov)
      ServiceSale.where(month: mov.created_at.month, year: mov.created_at.year, store: mov.store, service: mov.service).first
    end

    def store_sale(mov)
      StoreSale.where(month: mov.created_at.month, year: mov.created_at.year, store: mov.store).first
    end

    def create_product_sale(mov)
      create_reports_data(mov, ProductSale)
    end

    def update_product_sale(mov, object)
      update_reports_data(mov, object)
    end

    def create_service_sale(mov)
      create_reports_data(mov, ServiceSale)
    end

    def update_service_sale(mov, object)
      update_reports_data(mov, object)
    end

    def create_prospect_sale(mov)
      create_reports_data(mov, ProspectSale)
    end

    def update_prospect_sale(mov, object)
      update_reports_data(mov, object)
    end

    def create_store_sale(mov)
      create_reports_data(mov, StoreSale)
    end

    def update_store_sale(mov, object)
      update_reports_data(mov, object)
    end

    def create_business_unit_sale(mov)
      create_reports_data(mov, BusinessUnitSale)
    end

    def update_business_unit_sale(mov, object)
      update_reports_data(mov, object)
    end

    def create_business_group_sale(mov)
      create_reports_data(mov, BusinessGroupSale)
    end

    def update_business_group_sale(mov, object)
      update_reports_data(mov, object)
    end

    def update_reports_data(mov, object)
      subtotal = mov.subtotal
      discount = mov.discount_applied
      taxes = mov.taxes
      total = mov.total
      quantity = mov.quantity
      cost = mov.total_cost.to_f
      object.update_attributes(
        subtotal: object.subtotal + subtotal,
        discount: object.discount + discount,
        taxes: object.taxes + taxes,
        total: object.total + total,
        cost: object.cost + cost,
        quantity: object.quantity + quantity
      )
    end

    def create_reports_data(mov, object)
      new_object = object.new(
        subtotal: mov.subtotal,
        discount: mov.discount_applied,
        taxes: mov.taxes,
        total: mov.total,
        cost: mov.total_cost.to_f,
        quantity: mov.quantity,
        month: mov.created_at.month,
        year: mov.created_at.year
      )
      new_object.save
      update_particular_fields(new_object, mov)
    end

    def update_particular_fields(object, mov)
      if object.is_a?(ProductSale)
        object.update(product: mov.product, store: mov.store, business_unit: mov.store.business_unit)
      elsif object.is_a?(ServiceSale)
        object.update(service: mov.service, store: mov.store)
      elsif object.is_a?(ProspectSale)
        object.update(prospect: mov.ticket.prospect, store: mov.store)
      elsif object.is_a?(StoreSale)
        object.update(store: mov.store)
      elsif object.is_a?(BusinessUnitSale)
        object.update(business_unit: mov.store.business_unit)
      elsif object.is_a?(BusinessGroupSale)
        object.update(business_group: mov.store.business_unit.business_group)
      end
    end

    def create_only_payments(pay)
      StoreSale.create(payments: pay.total, store: pay.store, month: pay.created_at.month, year: pay.created_at.year)
    end

    def update_only_payments(pay, object)
      payments = object.payments.to_f + pay.total
      object.update_attributes(payments: payments, store: pay.store)
    end
    ### ESTA SECCIÓN DEBE IR A UN BACKGROUND JOB ###

end
