module Merb
  module GlobalHelpers
    # helpers defined here available to all views.  
    def gravater(email, size = 80, attrs = {})
      id = Digest::MD5.hexdigest(email)
      uri = "http://www.gravatar.com/avatar/#{id}?s=#{size}"
      tag :img, nil, {:src => uri, :width => size,
        :height => size, :border => 0}.merge(attrs)
    end

    def format(source)
      source.gsub(URI.regexp) do |uri|
        link_to h(uri), uri, :rel => 'nofollow'
      end.gsub("\n", "<br />\n")
    end
  end
end
