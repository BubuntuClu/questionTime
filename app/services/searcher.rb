class Searcher < ActiveRecord::Base
  EXCLUSION_ARRAY = ["all"]
  PER = 10
  
  def self.call(type, search, page)
    types = ApplicationController.helpers.get_types
    return [] unless types.include?(type)
    
    request = ThinkingSphinx::Query.escape(search.to_s)

    if (types - EXCLUSION_ARRAY).include?(type)
      @results = type.classify.constantize.search(request).page(page).per(PER)
    else
      @results = ThinkingSphinx.search(request).page(page).per(PER)
    end     
    @results
  end
end
