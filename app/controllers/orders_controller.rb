class OrdersController < ApplicationController
  before_action :authenticate_user!
  # Este controller relacionado a su modelo aún no tiene ningún avance pero es el que agrupará los movements o pending movements como parte de un pedido.

  def new
    #este only ‘store’ o ‘store-admin’
  end

  def catalog
  end

  def special
  end

  def index
  end
end
