class RequestMailer < ApplicationMailer
  include ApplicationHelper

  default from: "notificaciones@plataforma-dc.com"
#  default from: "faviovelez29@gmail.com"

  layout 'mailer'

  def status_cost_assigned(request)
    @request = request
    @user_email = @request.store.bill_email
    @user = request.users.first
      mail(
        to: @user_email,
        subject: "Costo asignado en pedido especial #{request.id}"
      )
  end

  def status_price_assigned(request)
    @request = request
    identify_manager_and_request(request)
    unless @manager.nil?
      mail(
        to: @manager.email,
        subject: "Precio asignado en pedido especial #{request.id}"
      )
    end
  end

  def status_unassigned(request)
    @advise_list = User.joins(:role).where(store_id: request.corporate_id, roles: {name: ['admin-desk']}).pluck(:email)
    @advise_list << request.order.store.bill_email
    @request = request
    mail(
      bcc: @advise_list,
      subject: "El producto #{request.product.unique_code} del pedido #{request.order.id} ya no está asignado"
    )

  end

  def status_authorised(request)
    @request = request
    @mails = []
    identify_manager_and_request(request)
    @mails << @manager.email unless @manager.nil?
    product_mails = User.joins(:role).where(roles: {name: ['product-admin', 'product-staff']}).pluck(:email)
    product_mails.each do |pm|
      @mails << pm
    end
      mail(
        bcc: @mails,
        subject: "El pedido especial #{request.id} ha sido confirmado"
      )
  end

  def status_cancelled(request)
    @request = request
    identify_manager_and_request(request)
    unless @manager.nil?
      mail(
        to: @manager.email,
        subject: "El pedido especial #{request.id} ha sido cancelado"
      )
    end
  end

  def request_reactivated(request)
    @request = request
    identify_manager_and_request(request)
    unless @manager.nil?
      mail(
        to: @manager.email,
        subject: "El pedido especial #{request.id} ha sido reactivado"
      )
    end
  end

  def send_authorisation(request)
    @request = request
    identify_store_users(request)
    @mails = []
    if request.prospect.email.present?
      @mails << request.prospect.email unless @mails.include?(request.prospect.email)
    end
    if request.prospect.email_2.present?
      @mails << request.prospect.email_2 unless @mails.include?(request.prospect.email_2)
    end
    if request.prospect.email_3.present?
      @mails << request.prospect.email_3 unless @mails.include?(request.prospect.email_3)
    end
    description(request)
    username(request)
    request_address(request)
    product_total(request)
    calculate_tax(request)
    sum_total(request)

    attachments['Autorización.pdf'] = WickedPdf.new.pdf_from_string(
      render_to_string(pdf: "Autorización", template: 'requests/authorisation_mail_doc', page_size: 'Letter', layout: 'authorisation.html')
    )
    @store_mails.each do |mail|
      @mails << mail
    end
    mail(
      bcc: @mails,
      subject: "Autorización de Pedido Diseños de Cartón #{request.store.store_name}"
    )
  end

  def send_estimate(request)
    @request = request
    identify_store_users(request)
    @mails = []
    if request.prospect.email.present?
      @mails << request.prospect.email unless @mails.include?(request.prospect.email)
    end
    if request.prospect.email_2.present?
      @mails << request.prospect.email_2 unless @mails.include?(request.prospect.email_2)
    end
    if request.prospect.email_3.present?
      @mails << request.prospect.email_3 unless @mails.include?(request.prospect.email_3)
    end
    description(request)
    username(request)
    request_address(request)
    attachments['Cotización.pdf'] = WickedPdf.new.pdf_from_string(
      render_to_string(pdf: "Cotización", template: 'requests/estimate_mail_doc', page_size: 'Letter', layout: 'estimate.html')
    )
    @store_mails.each do |mail|
      @mails << mail
    end
    mail(
      bcc: @mails,
      subject: "Cotización Diseños de Cartón #{request.store.store_name}"
    )
  end

  def identify_store_users(request)
    @store_mails = []
    store_role_id = Role.find_by_name('store').id
    store_admin_role_id = Role.find_by_name('store-admin').id
    store_role = request.users.where("role_id = ? OR role_id = ?", store_role_id, store_admin_role_id)
#    @store_mails << store_role.first.email
    @store_mails << request.store.bill_email unless @store_mails.include?(request.store.bill_email)
  end

  def identify_manager_and_request(request)
    @request = request
    manager_role_id = Role.find_by_name('manager').id
    director_role_id = Role.find_by_name('director').id
    manager = request.users.where("role_id = ? OR role_id = ?", manager_role_id, director_role_id)
    @manager = manager.first
  end

end
