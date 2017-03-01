class SearchesController < ApplicationController
  
  respond_to :html
  def index
    return [] unless %w(question answer comment user all).include?(params[:search_type])
    
    if %w(question answer comment user).include?(params[:search_type])
      @results = params[:search_type].classify.constantize.search(params[:search]).page(params[:page]).per(10)
    else
      @results = ThinkingSphinx.search(params[:search]).page(params[:page]).per(10)
    end      
    respond_with(@results)
  end
end
