class RequestMailer < ApplicationMailer

  default from: "faviovelez29@gmail.com"
  layout 'mailer'

  def status_change_to_store(request)
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

  def status_change_to_manager(request)
    @request = request
    manager = request.users.find_by_role_id(2)
    @manager = manager
      mail(
        to: manager.email,
        subject: "Precio asignado en solucitud #{request.id}"
      )
  end

end
