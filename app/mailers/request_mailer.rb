class RequestMailer < ApplicationMailer

  default from: "notificaciones@plataforma-dc.com"
#  default from: "faviovelez29@gmail.com"

  layout 'mailer'

  def status_cost_assigned(request)
    @request = request
    @request.store.users.each do |user|
      @user = user
    end
    list = request.store.users
      mail(
        bcc: list.map(&:email).uniq,
        subject: "Costo asignado en solicitud #{request.id}"
      )
  end

  def status_price_assigned(request)
    @request = request
    identify_manager_and_request(request)
      mail(
        to: @manager.email,
        subject: "Precio asignado en solucitud #{request.id}"
      )
  end

  def status_authorised(request)
    @request = request
    identify_manager_and_request(request)
      mail(
        to: @manager.email,
        subject: "La solicitud #{request.id} ha sido confirmada"
      )
  end

  def status_cancelled(request)
    @request = request
    identify_manager_and_request(request)
      mail(
        to: @manager.email,
        subject: "La solicitud #{request.id} ha sido cancelada"
      )
  end

  def request_reactivated(request)
    @request = request
    identify_manager_and_request(request)
      mail(
        to: @manager.email,
        subject: "La solicitud #{request.id} ha sido reactivada"
      )
  end

  def identify_manager_and_request(request)
    @request = request
    manager_role_id = Role.find_by_name('manager').id
    director_role_id = Role.find_by_name('director').id
    manager = request.users.where("role_id = ? OR role_id = ?", manager_role_id, director_role_id)
    @manager = manager.first
  end

end
