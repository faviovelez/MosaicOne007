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

  def date_filter
    get_report_type
    get_array_type
  end

end
