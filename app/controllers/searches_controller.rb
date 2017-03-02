class SearchesController < ApplicationController
  
  respond_to :html

  def index
    respond_with(@results = Search.run(params[:search_type], params[:search], params[:page]))
  end
end
