class Plugins < Application
  aggregates :show => :reports
  before :append_title
  # provides :xml, :yaml, :js

  def index
    provides :atom
    @plugins = Plugin.desc.paginate(params.merge(:per_page => 20))
    display @plugins
  end

  def show(id)
    @plugin = Plugin.get(id)
    raise NotFound unless @plugin
    @report = @plugin.reports.new
    prepend_plugin_name_to_title(@plugin)
    display @plugin
  end

  def new
    only_provides :html
    @plugin = Plugin.new
    display @plugin
  end

  def edit(id)
    only_provides :html
    @plugin = Plugin.get(id)
    raise NotFound unless @plugin
    prepend_plugin_name_to_title(@plugin)
    display @plugin
  end

  def create(plugin)
    @plugin = Plugin.new(plugin)
    @plugin.user = session.user
    if @plugin.save
      redirect resource(@plugin), :message => {:notice => "Plugin was successfully created"}
    else
      message[:error] = "Plugin failed to be created"
      render :new
    end
  end

  def update(id, plugin)
    @plugin = Plugin.get(id)
    raise NotFound unless @plugin
    raise Unauthorized unless @plugin.user == session.user
    if @plugin.update_attributes(plugin)
      redirect resource(@plugin)
    else
      display @plugin, :edit
    end
  end

  def destroy(id)
    @plugin = Plugin.get(id)
    raise NotFound unless @plugin
    raise Unauthorized unless @plugin.user == session.user
    if @plugin.destroy
      redirect resource(:plugins)
    else
      raise InternalServerError
    end
  end

private
  def append_title
    @title += " Plugins"
  end

  def prepend_plugin_name_to_title(plugin)
    @title = "#{plugin.name} - #{@title}"
  end
end # Plugins
