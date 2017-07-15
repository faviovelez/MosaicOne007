class SearchSuggestion

  def self.seed
    Product.find_each do |place|
      description = Product.description
      1.upto(description.length - 1) do |n|
        prefix = description[0, n]
        $redis.zadd 'search-suggestions:#{prefix.downcase}', 1, description.downcase
      end
    end
  end

  def self.terms_for(prefix)
    $redis.zrevrange 'search-suggestions:#{prefix.downcase}', 0, 9
  end

end
