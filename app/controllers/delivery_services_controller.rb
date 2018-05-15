class DeliveryServicesController < ApplicationController

  def report_type
    if params[:options] == 'Seleccionar día'
      date = Date.parse(params[:date]) unless (params[:date] == nil || params[:date] == '')
      initial_date = date.midnight + 6.hours
      final_date = date.end_of_day + 6.hours
    elsif params[:options] == 'Mes actual'
      intial_date = Date.today.beginning_of_month.midnight + 6.hours
      final_date = Date.today + 6.hours
    else
      initial_date = Date.parse(params[:initial_date]).midnight + 6.hours unless (params[:initial_date] == nil || params[:initial_date] == '')
      final_date = Date.parse(params[:final_date]).end_of_day + 6.hours unless (params[:final_date] == nil || params[:final_date] == '')
    end
    if params[:report_type] == 'Ventas'
      if params[:companies].include?('Todas')
        @delivery_services = ServiceOffered.includes(:ticket, :service, :delivery_service).where(store_id: current_user.store.id, created_at: initial_date..final_date, tickets: {ticket_type: ['venta', 'devolución']}).where.not(ticket_id: nil, services: {delivery_company: nil}).order(:id)
      else
        companies = params[:companies]
        @delivery_services = ServiceOffered.includes(:ticket, :service, :delivery_service).where(store_id: current_user.store.id, created_at: initial_date..final_date, services: {delivery_company: companies}, tickets: {ticket_type: ['venta', 'devolución']}).where.not(ticket_id: nil).order(:id)
      end
      if @delivery_services == []
        redirect_to root_path, alert: 'La fecha seleccionada no tiene registros, por favor elija otra'
      else
        render 'delivery_services_report'
      end
    elsif params[:report_type] == 'Base de datos'
      if params[:companies].include?('Todas')
        @delivery_services = DeliveryService.includes(service_offered: :ticket).where(store_id: current_user.store.id, created_at: initial_date..final_date, tickets: {ticket_type: ['venta', 'devolución']}).where.not(service_offereds: {ticket_id: nil}).order(:id)
      else
        companies = params[:companies]
        @delivery_services = DeliveryService.includes(service_offered: [:ticket, :service]).where(store_id: current_user.store.id, created_at: initial_date..final_date, services: {delivery_company: companies}, tickets: {ticket_type: ['venta', 'devolución']}).where.not(service_offereds: {ticket_id: nil}).order(:id)
      end
      if @delivery_services == []
        redirect_to root_path, alert: 'La fecha seleccionada no tiene registros, por favor elija otra'
      else
        render 'delivery_services_database'
      end
    end
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
    redirect_to delivery_services_show_report_path(service_offered.id), notice: 'Se ha guardado el costo con éxito'
  end

  def show_database
    @delivery_service = DeliveryService.find(params[:id])
  end

  def show_report
    @service_offered = ServiceOffered.find(params[:id])
  end

end
