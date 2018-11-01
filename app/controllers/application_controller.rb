class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def process_product_request
    @entries = WarehouseEntry.where(
      product: @product_request.product
    ).order("created_at #{order_type}")
    if process_entries
      @product_request.product.update_inventory_quantity(
        @product_request.quantity
      )
    end
  end

  def dates_generator(array)
    string = "DATE_TRUNC('month', "
    if array.first.class == BillReceived
      string += array.first.class.to_s.pluralize.underscore + ".date_of_bill" + ")"
    elsif array.first.class == Payment
      string += array.first.class.to_s.pluralize.underscore + ".payment_date" + ")"
    else
      string += array.first.class.to_s.pluralize.underscore + ".created_at" + ")"
    end
    if array.first.class == Payment
      options = array.first.class.where(store_id: nil).pluck(string).uniq
    elsif array.first.class == Order
      options = array.first.class.where(corporate_id: current_user.store.id).pluck(string).uniq
    else
      options = array.first.class.where(store_id: current_user.store.id).pluck(string).uniq
    end
    @month_options = options.map{ |arr| arr.to_date.strftime('%m/%Y') }
  end

  def get_array_type
    if @report_type == "cancel payments bills received"
      array = BillReceived.where(store_id: current_user.store.id).limit(2)
      dates_generator(array)
    elsif @report_type == "cancel payments bills issued"
      array = Bill.where(store_id: current_user.store.id).limit(2)
      dates_generator(array)
    end
  end

  def get_report_type
    @report_type = params[:report_type]
  end

  def filter_date
    @initial_date = "#{params[:date].slice(3..7)}-#{params[:date].slice(0..1)}-01 00:00:00"
    @final_date = Date.parse(@initial_date).end_of_month.strftime('%F 23:59:59')
  end

  def reverse_params_array
    n = 0
    params.length.times do
      params.values[n].reverse! if params.values[n].class == Array
      n += 1
    end
  end

  def order_type
    current_user.store.cost_type.warehouse_cost_type == 'PEPS' ? 'ASC' : 'DESC'
  end

  def process_entries
    pending_order = @product_request.quantity
    @entries.each do |entry|
      if pending_order >= entry.fix_quantity
        create_movement(Movement).update_attributes(
          quantity: entry.fix_quantity,
          cost: entry.movement.fix_cost * entry.fix_quantity
        )
        pending_order -= Movement.last.fix_quantity
        entry.destroy
      else
        create_movement(Movement).update_attributes(
          quantity: pending_order,
          cost: entry.movement.fix_cost * pending_order
        )
        entry.update(quantity: (entry.fix_quantity - pending_order) )
        break
      end
    end
    true
  rescue
    return false
  end

  def banned_prospects_validation
    bills = Bill.where(payed: false, store_id: [1, 2]).pluck(:created_at, :total, :folio, :id)
    bills.each_with_index do |val, index|
      bill = Bill.find(val[3])
      bills[index] << bill.payments.sum(:total)
      bills[index] << bill.prospect.id
      bills[index] << bill.prospect.credit_days.to_i
    end

    bills.each do |bill|
      prospect = bill
      bill[0] = bill[0].to_date + bill[6].days + 10.days
    end

    @banned_prospects = []
    bills.each_with_index do |val, index|
      if Date.today > val[0]
        if (val[1].to_f - val[4].to_f).round(2) > 1
          @banned_prospects << val[5] unless @banned_prospects.include?(val[5])
        end
      end
    end
  end

  def products_for_report
    @products = []
    role = current_user.role.name
    @store = current_user.store
    Product.where(current: true, shared: true).each do |product|
      @products << ["#{product.unique_code} #{product.description}", product.id]
    end
    if role == 'store-admin' || role == 'store'
      @store_products = Product.where(store: @store)
      if @store_products != []
        @store_products.each do |p|
          @products << ["#{p.unique_code} #{p.description}", p.id]
        end
      end
    end
    @products
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) do |user_params|
        user_params.permit(:first_name, :middle_name, :last_name, :store_id, :role_id, :email, :password, :password_confirmation)
      end
      devise_parameter_sanitizer.permit(:account_update) do |user_params|
        user_params.permit(:first_name, :middle_name, :last_name, :store_id, :role_id, :email, :password, :password_confirmation, :current_password)
      end

    end
end
