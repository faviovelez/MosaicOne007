class SearchSuggestionsController < ApplicationController
  # Intentaba usar redis para hacer un formulario de búsqueda y guardar los resultados de manera que los sugiriera con autocompletar pero no he terminado.
  def index
    render json: SearchSuggestion.terms_for(params[:term])
  end

end
