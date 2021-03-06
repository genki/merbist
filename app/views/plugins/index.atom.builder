xml.instruct! :xml, :version=>"1.0" 
xml.feed(:xmlns => "http://www.w3.org/2005/Atom") do |feed|
  feed.title "Plugins for Merbist"
  feed.link :type => 'text/html', :rel => 'alternate',
    :href => full_resource(:plugins)

  @plugins.each do |plugin|
    feed.entry do |entry|
      entry.id plugin.id
      entry.title plugin.name
      entry.content plugin.description, :type => 'text'
      entry.issued plugin.created_at
      entry.modified plugin.updated_at
      entry.link :type => "text/html", :rel => "alternate",
        :href => full_resource(plugin)
      entry.author do |author|
        author.name plugin.user.login
      end
    end
  end
end
