class PagesController < ApplicationController
  before_action :authenticate_user!
  # Pantalla principal de la aplicación.
  def index
  end
end
