class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show_for_store, :change_delivery_address]
  before_action :reverse_params_array, only: [:save_products, :save_products_for_prospects]

  def new(role = current_user.role.name)
    @order = Order.new(store: current_user.store,
                       category: 'de línea',
                       prospect: Prospect.find_by_store_prospect_id(current_user.store)
                      )
    @order.users << current_user
    redirect_to root_path, alert: 'No cuenta con los permisos necesarios.' unless (role == 'store' || role == 'store-admin')
  end

  def new_order_for_prospects(role = current_user.role.name)
    @prospect = Prospect.find(params[:prospect_id])
    @order = Order.new(store: current_user.store,
                       category: 'de línea',
                       prospect: @prospect
                      )
    @order.users << current_user
    redirect_to root_path, alert: 'No cuenta con los permisos necesarios.' unless (role == 'admin-desk')
  end

  def show
    update_order_total
  end

  def update_order_total
    if params[:ids].present?
      @orders = Order.find(params[:ids].split('/'))
    else
      @orders = Order.where(id:params[:id])
    end
    @orders.each do |order|
      cost = 0
      subtotal = 0
      discount = 0
      taxes = 0
      total = 0
      if order.movements != []
        order.movements.each do |mov|
          if mov.quantity == nil
            mov.delete
          else
            if mov.movement_type == 'venta'
              cost += mov.total_cost.to_f
              subtotal += mov.subtotal.to_f
              discount += mov.discount_applied.to_f
              taxes += mov.taxes.to_f
              total += mov.total.to_f
            elsif mov.movement_type == 'devolución'
              cost -= mov.total_cost.to_f
              subtotal -= mov.subtotal.to_f
              discount -= mov.discount_applied.to_f
              taxes -= mov.taxes.to_f
              total -= mov.total.to_f
            end
          end
        end
      end
      order.pending_movements.each do |mov|
        if mov.quantity == nil
          mov.delete
        else
          product = mov.product
          if product.group
            if mov.movement_type == 'venta'
              cost += mov.total_cost.to_f * mov.quantity * product.average
              subtotal += mov.subtotal.to_f * mov.quantity * product.average
              discount += mov.discount_applied.to_f * mov.quantity * product.average
              taxes += mov.taxes.to_f * mov.quantity * product.average
              total += (mov.subtotal.to_f * mov.quantity * product.average) - (mov.discount_applied.to_f * mov.quantity * product.average) + (mov.taxes.to_f * mov.quantity * product.average)
            elsif mov.movement_type == 'devolución'
              cost -= mov.total_cost.to_f * mov.quantity * product.average
              subtotal -= mov.subtotal.to_f * mov.quantity * product.average
              discount -= mov.discount_applied.to_f * mov.quantity * product.average
              taxes -= mov.taxes.to_f * mov.quantity * product.average
              total -= (mov.subtotal.to_f * mov.quantity * product.average) - (mov.discount_applied.to_f * mov.quantity * product.average) + (mov.taxes.to_f * mov.quantity * product.average)
            end
          else
            if mov.movement_type == 'venta'
              cost += mov.total_cost.to_f * mov.quantity
              subtotal += mov.subtotal.to_f * mov.quantity
              discount += mov.discount_applied.to_f * mov.quantity
              taxes += mov.taxes.to_f * mov.quantity
              total += (mov.subtotal.to_f * mov.quantity) - (mov.discount_applied.to_f * mov.quantity) + (mov.taxes.to_f * mov.quantity)
            elsif mov.movement_type == 'devolución'
              cost -= mov.total_cost.to_f * mov.quantity
              subtotal -= mov.subtotal.to_f * mov.quantity
              discount -= mov.discount_applied.to_f * mov.quantity
              taxes -= mov.taxes.to_f * mov.quantity
              total -= (mov.subtotal.to_f * mov.quantity) - (mov.discount_applied.to_f * mov.quantity) + (mov.taxes.to_f * mov.quantity)
            end
          end
        end
      end
      subtotal = subtotal.round(2)
      discount = discount.round(2)
      taxes = taxes.round(2)
      cost = cost.round(2)
      total = total.round(2)
      order.update(
        subtotal: subtotal,
        discount_applied: discount,
        taxes: taxes,
        total: total,
        cost: cost
      )
    end
    orders_total = 0
    @orders.each do |order|
      orders_total += order.total
    end
    @orders_total = orders_total
  end

  def show_for_store
    update_order_total
    @order = Order.find(params[:id])
  end

  def confirm_received
    order = Order.find(params[:order_id])
    if params[:order_complete]
      order.update(status: 'entregado', deliver_complete: true, confirm_user: current_user)
      requests = order.product_requests.where.not(status: 'cancelada')
      requests.each do |request|
        request.update(status: 'entregado')
        request.movements.each do |mov|
          new_mov = mov.as_json
          new_mov.delete("id")
          new_mov.delete("created_at")
          new_mov.delete("updated_at")
          new_mov.delete("identifier")
          new_mov.delete("seller_user_id")
          new_mov.delete("buyer_user_id")
          new_mov.delete("business_unit_id")
          new_mov.delete("unique_code")
          new_mov.delete("entry_movement_id")
          new_mov.delete("discount_rule_id")
          new_mov.delete("confirm")
          new_mov.delete("maximum_date")
          new_mov.delete("kg")
          new_mov["web"] = true
          new_mov["pos"] = false
          new_mov["reason"] = "Pedido #{order.id}"
          new_mov["movement_type"] = 'alta automática'
          new_mov["store_id"] = current_user.store.id
          StoreMovement.create(new_mov)
        end
      end
    else
      requests = ProductRequest.find(params[:id])
      complete = true
      alert = ""
      requests.each_with_index do |request,index|
        complete = false if (params[:excess][index].to_i != 0 || params[:surplus][index].to_i != 0)
        if params[:excess][index].to_i != 0
          alert = "Sobran #{params[:excess][index].to_i} piezas"
        elsif params[:surplus][index].to_i != 0
          alert = "Faltan #{params[:surplus][index].to_i} piezas"
        end
        # Posiblemente un mailer que avise de los faltantes
        request.update(status: 'entregado', quantity: request.quantity.to_i + params[:excess][index].to_i - params[:surplus][index].to_i, alert: alert)
        request.movements.each do |mov|
          new_mov = mov.as_json
          new_mov.delete("id")
          new_mov.delete("created_at")
          new_mov.delete("updated_at")
          new_mov.delete("identifier")
          new_mov.delete("seller_user_id")
          new_mov.delete("buyer_user_id")
          new_mov.delete("business_unit_id")
          new_mov.delete("unique_code")
          new_mov.delete("entry_movement_id")
          new_mov.delete("discount_rule_id")
          new_mov.delete("confirm")
          new_mov.delete("maximum_date")
          new_mov.delete("kg")
          new_mov["web"] = true
          new_mov["pos"] = false
          new_mov["reason"] = "Pedido #{order.id}"
          new_mov["movement_type"] = 'alta automática'
          new_mov["store_id"] = current_user.store.id
          new_mov["quantity"] = new_mov["quantity"].to_i + params[:excess][index].to_i - params[:surplus][index].to_i
          StoreMovement.create(new_mov)
        end
      end
      order.update(status: 'entregado', deliver_complete: complete, confirm_user: current_user)
    end
    redirect_to store_orders_path(current_user.store), notice: "El pedido #{order.id} ha sido confirmado como entregado"
  end

  def get_product
    product = Product.find(params[:product])
    if product.present?
      render json: {
                    product: product,
                    images: product.images,
                    inventory: product.valid_inventory,
                   }
    else
      render json: {product: false}
    end
  end

  def _product_details
    @product = Product.find(params[:product])
  end

  def delete_product_from_order
    # Este método funciona independientemente de si ya se facturó
    request = ProductRequest.find(params[:id])
    product = request.product
    order = request.order
    @id = order.id
    total = order.total
    subtotal = order.subtotal
    taxes = order.taxes
    discount_applied = order.discount_applied
    order.movements.each do |mov|
      if mov.product == product
        number = WarehouseEntry.where(product: product).order(:id).last.entry_number.to_i
        entry_mov = mov.entry_movement
        entry = WarehouseEntry.create(quantity: mov.quantity, product: mov.product, movement: entry_mov, entry_number: number.next)
        inventory = Inventory.find_by_product_id(product.id)
        inventory_quantity = inventory.quantity
        new_quantity = inventory_quantity + mov.quantity
        inventory.update(quantity: new_quantity)
        total -= mov.total
        subtotal -= mov.subtotal
        taxes -= mov.taxes
        discount_applied -= mov.discount_applied
        down_mov = mov.dup
        down_mov.update_attributes(
          movement_type: 'devolución'
        )
      end
    end
    order.pending_movements.each do |mov|
      if mov.product == product
        total -= mov.total
        subtotal -= mov.subtotal
        taxes -= mov.taxes
        discount_applied -= mov.discount_applied
        mov.delete
      end
    end
    request.update(status: 'cancelada')
    if order.product_requests.where.not(status: 'cancelada').count < 1
      order.update(status: 'cancelado')
      redirect_to root_path, notice: 'Se canceló por completo el pedido.'
    else
      order.update(total: total, subtotal: subtotal, taxes: taxes, discount_applied: discount_applied)
      redirect_to orders_show_for_store_path(order), notice: 'Se canceló este producto de su pedido.'
    end
  end

  def delete_product_requests(request)
    # Este método es casi igual al anterior pero acepta un parámetro (para cuando se eliminan toda la order), solo si no se ha procesado
    product = request.product
    order = request.order
    total = order.total
    subtotal = order.subtotal
    taxes = order.taxes
    discount_applied = order.discount_applied
    order.movements.each do |mov|
      # Falta el proceso que los quita de los reportes
      if mov.product == product
        number = WarehouseEntry.where(product: product).order(:id).last.entry_number.to_i
        entry_mov = mov.entry_movement
        entry = WarehouseEntry.create(quantity: mov.quantity, product: mov.product, movement: entry_mov, entry_number: number.next)
        inventory = Inventory.find_by_product_id(product.id)
        inventory_quantity = inventory.quantity
        new_quantity = inventory_quantity + mov.quantity
        inventory.update(quantity: new_quantity)
        total -= mov.total
        subtotal -= mov.subtotal
        taxes -= mov.taxes
        discount_applied -= mov.discount_applied
        down_mov = mov.dup
        down_mov.update_attributes(
          movement_type: 'devolución'
        )
      end
    end
    order.pending_movements.each do |mov|
      total -= mov.total
      subtotal -= mov.subtotal
      taxes -= mov.taxes
      discount_applied -= mov.discount_applied
      mov.delete if mov.product == product
    end
    request.update(status: 'cancelada')
    if order.product_requests.where.not(status: 'cancelada').count < 1
      order.update(status: 'cancelado')
    else
      order.update(total: total, subtotal: subtotal, taxes: taxes, discount_applied: discount_applied)
    end
  end

  def delete_order
    # Este método es solo si no se ha facturado o procesado
    order = Order.find(params[:id])
    order.product_requests.each do |request|
      delete_product_requests(request)
    end
    orders_users = OrdersUser.find_by_order_id(order.id)
    orders_users.delete
    order.update(status: 'cancelado')
    redirect_to root_path, notice: 'Se canceló por completo el pedido.'
  end

  def save_products
    @store = Store.find(params[:store_id])
    @prospect = Prospect.find_by_store_prospect_id(current_user.store)
    corporate = Store.joins(:store_type).where(store_types: {store_type: 'corporativo'}).first
    status = []
    prod_req = []
    movs = []
    pend_movs = []
    @order = Order.create(
                            store: current_user.store,
                            request_user: current_user,
                            category: 'de línea',
                            corporate: corporate,
                            status: 'en espera',
                            delivery_address: current_user.store.delivery_address,
                            prospect: @prospect
                          )
    @order.update(deliver_complete: true) if params[:deliver_complete] == "true"
    @order.users << current_user
    @order.save
    create_product_requests
    @order.product_requests.each do |pr|
      status << [pr.status]
      prod_req << pr
    end
    if status.uniq.length != 1
      if !(@order.deliver_complete)
        @order.movements.each do |mov|
          movs << mov
        end
        @order.pending_movements.each do |mov|
          pend_movs << mov
        end
        @new_order = Order.create(store: current_user.store,
          request_user: current_user,
          category: 'de línea',
          corporate: corporate,
          delivery_address: current_user.store.delivery_address,
          status: 'en espera',
          prospect: @prospect
        )
        assigned_mov = []
        unassigned_pr = []
        assigned_pr = []
        pendings = []
        prod_req.each do |pr|
          pend_movs.each do |pm|
            pendings << pm if (pm.product_id == pr.product_id && (pendings.include?(pm) == false))
            unassigned_pr << pr if (pm.product_id == pr.product_id && (unassigned_pr.include?(pr) == false))
          end
          movs.each do |mov|
            assigned_mov << mov if (pr.product_id == mov.product_id && (assigned_mov.include?(mov) == false))
            assigned_pr << pr if (pr.product_id == mov.product_id && (assigned_pr.include?(pr) == false))
          end
        end
        pendings.each do |pend|
          PendingMovement.find(pend.id).update(order: @new_order)
        end
        unassigned_pr.each do |pr|
          ProductRequest.find(pr.id).update(order: @new_order)
        end
      end
    else
      if status.first == ['asignado']
        @order.update(status: 'mercancía asignada')
      end
    end
    @orders = []
    @orders << @order.id
    @orders << @new_order.id unless @new_order == nil
    redirect_to orders_show_path(@orders), notice: 'Todos los registros almacenados.'
  end

  def save_products_for_prospects
    @prospect = Prospect.find(params[:prospect_id])
    status = []
    prod_req = []
    movs = []
    pend_movs = []
    @order = Order.create(
                            store: current_user.store,
                            request_user: current_user,
                            corporate: current_user.store,
                            category: 'de línea',
                            status: 'en espera',
                            delivery_address: current_user.store.delivery_address,
                            prospect: @prospect
                          )
    @order.update(deliver_complete: true) if params[:deliver_complete] == "true"
    @order.users << current_user
    @order.save
    create_product_requests
    @order.product_requests.each do |pr|
      status << [pr.status]
      prod_req << pr
    end
    if status.uniq.length != 1
      if !(@order.deliver_complete)
        @order.movements.each do |mov|
          movs << mov
        end
        @order.pending_movements.each do |mov|
          pend_movs << mov
        end
        @new_order = Order.create(store: current_user.store,
          request_user: current_user,
          category: 'de línea',
          corporate: current_user.store,
          delivery_address: current_user.store.delivery_address,
          status: 'en espera',
          prospect: @prospect
        )
        assigned_mov = []
        unassigned_pr = []
        assigned_pr = []
        pendings = []
        prod_req.each do |pr|
          pend_movs.each do |pm|
            pendings << pm if (pm.product_id == pr.product_id && (pendings.include?(pm) == false))
            unassigned_pr << pr if (pm.product_id == pr.product_id && (unassigned_pr.include?(pr) == false))
          end
          movs.each do |mov|
            assigned_mov << mov if (pr.product_id == mov.product_id && (assigned_mov.include?(mov) == false))
            assigned_pr << pr if (pr.product_id == mov.product_id && (assigned_pr.include?(pr) == false))
          end
        end
        pendings.each do |pend|
          PendingMovement.find(pend.id).update(order: @new_order)
        end
        unassigned_pr.each do |pr|
          ProductRequest.find(pr.id).update(order: @new_order)
        end
      end
    else
      if status.first == ['asignado']
        @order.update(status: 'mercancía asignada')
      end
    end
    @orders = []
    @orders << @order.id
    @orders << @new_order.id unless @new_order == nil
    redirect_to orders_show_path(@orders), notice: 'Todos los registros almacenados.'
  end

  def confirm
    @orders = Order.find(params[:ids].split('/'))
    @orders.each do |order|
      order.movements.each do |mov|
        mov.update(confirm: true)
      end
      order.update(confirm: true)
    end
    redirect_to store_orders_path(@orders.first.store),
      notice: 'Registros confirmados'
  end

  def change_delivery_address
    delivery = params[:order][:delivery_address]
    address = DeliveryAddress.find(delivery) unless (delivery == 'otra dirección' || delivery == 'seleccione' || delivery == '')
    notes = params[:order][:delivery_notes] unless address.present?
    if (address == nil && notes.blank?)
      redirect_to show_for_store, notice: 'Por favor ingrese una dirección o elija otra y anote la dirección completa en el campo correspondiente.'
    else
      if address.nil?
        @order.delivery_address = nil
      else
        @order.delivery_address = address
      end
      @order.delivery_notes = notes unless notes.nil?
      if @order.save
        redirect_to store_orders_path(current_user.store), notice: 'La dirección se actualizó correctamente.'
      else
        redirect_to show_for_store, notice: 'Hubo un error, por favor ingrese una dirección o elija otra y anote la dirección completa en el campo correspondiente.'
      end
    end
  end

  def index
    current_orders
  end

  def current_orders
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      @orders = Order.where.not(status: ['entregado', 'cancelado', 'expirado']).where(store: current_user.store).order(:created_at)
    else
      @orders = Order.where.not(status: ['entregado', 'cancelado', 'expirado']).where(corporate: current_user.store).order(:created_at)
    end
  end

  def delivered_orders
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      @orders = Order.where(status:'entregado', store: current_user.store).order(:created_at)
    else
      @orders = Order.where(status:'entregado', corporate: current_user.store).order(:created_at)
    end
  end

  def history
    delivered_orders
  end

  def cancelled
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      @orders = Order.where(store: current_user.store, status: 'cancelado')
    else
      @orders = Order.where(status: 'cancelado', corporate: current_user.store)
    end
  end


  private

  def create_product_requests
    counter = params[:products].count
    n = 0
    converted_armed = false
    if params[:armed][n] == 'true'
      converted_armed = true
    end
    counter.times do
      product = Product.find(params[:products][n])
      product_request = ProductRequest.create(
        product: product,
        quantity: params[:request][n],
        armed: converted_armed,
        order: @order
      )
      if product_request.save
        passing_validation(product_request, n)
      end
      n += 1
    end
  end

  def passing_validation(product_request, n)
    order_quantity = product_request.quantity
    inventory = product_request.product.inventory
    product = product_request.product
    if @prospect.store_prospect != nil
      if (product.armed && params[:armed][n] == 'true')
        discount = product.armed_discount / 100
      else
        if @prospect.store_prospect.store_type.store_type == 'tienda propia'
          discount = product.discount_for_stores / 100
        elsif @prospect.store_prospect.store_type.store_type == 'franquicia'
          discount = product.discount_for_franchises / 100
        end
      end
    else
      discount = params[:discount][n].to_f / 100
    end
    if order_quantity > inventory.fix_quantity
      product_request.update(status: 'sin asignar')
      q = product_request.quantity
      mov = create_movement(PendingMovement, n, product_request)
    else
      Movement.new_object(
        product_request,
        current_user,
        'venta',
        discount,
        @prospect
        )
    end
  end

  def create_movement(object, n, product_request)
    product = product_request.product
    store = Store.find_by_store_name('Corporativo Compresor')
    prospect = @prospect
    if prospect.store_prospect != nil
      if (product.armed && params[:armed][n] == 'true')
        discount = product.armed_discount / 100
      else
        if prospect.store_prospect.store_type.store_type == 'tienda propia'
          discount = product.discount_for_stores / 100
        elsif prospect.store_prospect.store_type.store_type == 'franquicia'
          discount = product.discount_for_franchises / 100
        end
      end
    else
      discount = params[:discount][n].to_f / 100
    end
    price = ('%.2f' % product.price).to_f
    disc_app = ('%.2f' % (product.price * discount)).to_f
    unit_price = ('%.2f' % (price * (1 - discount))).to_f
    cost = ('%.2f' % product.cost.to_f).to_f
    movement = object.create(
      product: product,
      order: @order,
      unique_code: product.unique_code,
      quantity: product_request.quantity,
      store: store,
      initial_price: price,
      automatic_discount: disc_app,
      discount_applied: disc_app,
      supplier: product.supplier,
      final_price: unit_price,
      movement_type: 'venta',
      user: current_user,
      cost: cost,
      total: unit_price * 1.16,
      taxes: unit_price * 0.16,
      subtotal: product.price,
      business_unit: store.business_unit,
      product_request: product_request,
      maximum_date: product_request.maximum_date,
      prospect: prospect
    )
    movement
  end

  def set_order
    @order = Order.find(params[:id])
  end
end
