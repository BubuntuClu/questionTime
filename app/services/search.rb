class Search 
  TYPES = %w(question answer comment user all).freeze
  EXCLUSION_ARRAY = ["all"]
  PER = 10
  
  def self.run(type, search, page)
    return [] unless TYPES.include?(type)
    
    request = ThinkingSphinx::Query.escape(search.to_s)

    if (TYPES - EXCLUSION_ARRAY).include?(type)
      results = type.classify.constantize.search(request).page(page).per(PER)
    else
      results = ThinkingSphinx.search(request).page(page).per(PER)
    end     
    results
  end
end
