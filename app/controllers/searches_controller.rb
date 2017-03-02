class SearchesController < ApplicationController
  
  respond_to :html

  def index
    respond_with(@results = Searcher.call(params[:search_type], params[:search], params[:page]))
  end
end
