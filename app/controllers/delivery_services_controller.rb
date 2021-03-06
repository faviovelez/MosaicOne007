class DeliveryServicesController < ApplicationController

  def report_type
    if params[:options] == 'Seleccionar día'
      date = Date.parse(params[:date]) unless (params[:date] == nil || params[:date] == '')
      initial_date = date.midnight + 6.hours
      final_date = date.end_of_day + 6.hours
    elsif params[:options] == 'Mes actual'
      initial_date = Date.today.beginning_of_month.midnight + 6.hours
      final_date = Date.today + 6.hours
    else
      initial_date = Date.parse(params[:initial_date]).midnight + 6.hours unless (params[:initial_date] == nil || params[:initial_date] == '')
      final_date = Date.parse(params[:final_date]).end_of_day + 6.hours unless (params[:final_date] == nil || params[:final_date] == '')
    end
    if params[:store_options] == nil
      stores = current_user.store.id
    else
      if params[:store_options] == 'Todas las tiendas'
        stores = Store.joins(:store_type).where(store_types: {store_type: 'tienda propia'}).pluck(:id)
      elsif params[:store_options] == 'Tiendas y franquicias'
        stores = Store.all.pluck(:id)
      elsif params[:store_options] == 'Todas las franquicias'
        stores = Store.joins(:store_type).where(store_types: {store_type: 'franquicia'}).pluck(:id)
      else
        stores = params[:store_list]
      end
    end
    if params[:report_type] == 'Ventas'
      if params[:companies].include?('Todas')
        @delivery_services = ServiceOffered.includes(:ticket, :service, :delivery_service, :store).where(store_id: stores, created_at: initial_date..final_date, tickets: {ticket_type: ['venta', 'devolución']}).where.not(ticket_id: nil).order(:id)
      else
        companies = params[:companies]
        @delivery_services = ServiceOffered.includes(:ticket, :service, :delivery_service, :store).where(store_id: stores, created_at: initial_date..final_date, services: {delivery_company: companies}, tickets: {ticket_type: ['venta', 'devolución']}).where.not(ticket_id: nil).order(:id)
      end
      if @delivery_services == []
        redirect_to root_path, alert: 'La fecha seleccionada no tiene registros, por favor elija otra'
      else
        @day_quantity = @delivery_services.sum(:quantity)
        @day_subtotal = @delivery_services.sum(:subtotal)
        @day_discount = @delivery_services.sum(:discount_applied)
        @day_taxes = @delivery_services.sum(:taxes)
        @day_total = @delivery_services.sum(:total)
        @day_total_cost = (@delivery_services.sum(:total_cost) * 1.16).round(2)
        @day_total_margin = (@delivery_services.sum(:total) - (@delivery_services.sum(:total_cost) * 1.16).round(2)).round(2)
        render 'delivery_services_report'
      end
    elsif params[:report_type] == 'Base de datos'
      if params[:companies].include?('Todas')
        @delivery_services = DeliveryService.includes(:store, service_offered: :ticket).where(store_id: stores, created_at: initial_date..final_date, tickets: {ticket_type: ['venta', 'devolución']}).where.not(service_offereds: {ticket_id: nil}).order(:id)
      else
        companies = params[:companies]
        @delivery_services = DeliveryService.includes(:store, service_offered: [:ticket, :service]).where(store_id: stores, created_at: initial_date..final_date, services: {delivery_company: companies}, tickets: {ticket_type: ['venta', 'devolución']}).where.not(service_offereds: {ticket_id: nil}).order(:id)
      end
      if @delivery_services == []
        redirect_to root_path, alert: 'La fecha seleccionada no tiene registros, por favor elija otra'
      else
        render 'delivery_services_database'
      end
    end
  end

  def filter_for_viewers
  end

  def select_report
  end

  def delivery_services_database
  end

  def delivery_services_report
  end

  def cost_save_view
  end

  def save_cost
    total_cost = params[:total_cost]
    service_offered = ServiceOffered.find(params[:id])
    service_offered.update(total_cost: total_cost.to_f, cost: service_offered.total_cost.to_f / service_offered.quantity)
    redirect_to :back, notice: 'Se ha guardado el costo con éxito'
  end

  def show_database
    @delivery_service = DeliveryService.find(params[:id])
  end

  def show_report
    @service_offered = ServiceOffered.find(params[:id])
  end

end
