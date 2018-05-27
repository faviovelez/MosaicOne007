class OrderMailer < ApplicationMailer

  default from: "notificaciones@plataforma-dc.com"
#  default from: "faviovelez29@gmail.com"

  layout 'mailer'

  def status_on_delivery(order)
    @order = order
    identify_store_users(order)
    @user = order.users.first
    mail(
      to: @store_mails,
      subject: "El pedido #{order.id} ha está en camino para entregarse"
    )
  end

  def identify_store_users(order)
    @store_mails = []
    store_role_id = Role.find_by_name('store').id
    store_admin_role_id = Role.find_by_name('store-admin').id
    store_role = order.users.where("role_id = ? OR role_id = ?", store_role_id, store_admin_role_id)
#    @store_mails << store_role.first.email
    @store_mails << order.store.bill_email unless @store_mails.include?(order.store.bill_email)
  end

end
