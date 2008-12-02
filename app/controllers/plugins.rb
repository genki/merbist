class Plugins < Application
  # provides :xml, :yaml, :js

  def index
    @plugins = Plugin.all
    display @plugins
  end

  def show(id)
    @plugin = Plugin.get(id)
    raise NotFound unless @plugin
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
    display @plugin
  end

  def create(plugin)
    @plugin = Plugin.new(plugin)
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
    if @plugin.update_attributes(plugin)
       redirect resource(@plugin)
    else
      display @plugin, :edit
    end
  end

  def destroy(id)
    @plugin = Plugin.get(id)
    raise NotFound unless @plugin
    if @plugin.destroy
      redirect resource(:plugins)
    else
      raise InternalServerError
    end
  end

end # Plugins
