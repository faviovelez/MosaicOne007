class PagesController < ApplicationController
  before_action :authenticate_user!
  # Pantalla principal de la aplicación.
  def index
  end

  def utilerias
    @utilerias = File.read(Rails.root.join('lib', 'sat', 'utilerias.xslt'))
    respond_to do |format|
      format.xml { render  xml: @utilerias }
    end
  end
end
