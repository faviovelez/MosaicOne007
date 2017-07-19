class PagesController < ApplicationController
  before_action :authenticate_user!
  # Probablemente después borre este controller si no es necesario.
  def index
  end
end
