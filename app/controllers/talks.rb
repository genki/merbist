class Talks < Application
  before :append_title
  # provides :xml, :yaml, :js

  def index
    @talks = Talk.desc.paginate(params.merge(:per_page => 20))
    @talk = Talk.new
    display @talks
  end

  def show(id)
    only_provides :js
    @talk = Talk.get(id)
    display (Talk.last != @talk ? 1:0), :layout => false
  end

  def create(talk)
    @talk = Talk.new(talk)
    @talk.user = session.user
    @talk.created_at = DateTime.now
    if @talk.save
      redirect resource(:talks),
        :message => {:notice => "Talk was successfully created"}
    else
      message[:error] = "Talk failed to be created"
      render :index
    end
  end

  def destroy(id)
    @talk = Talk.get(id)
    raise NotFound unless @talk
    raise Unauthorized unless @talk.user == session.user
    if @talk.destroy
      redirect resource(:talks)
    else
      raise InternalServerError
    end
  end

private
  def append_title
    @title += " Talks"
  end
end # Talks
