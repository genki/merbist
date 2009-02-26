class Reports < Application
  def list
    @reports = Report.desc.paginate(params.merge(:per_page => 10))
  end

  def new
    @report = Report.new
  end

  def edit(id)
    @report = Report.get(id)
  end

  def create(report)
    @report = Report.new(report)
    @report.user = session.user
    @report.save
  end

  def update(id, report)
    @report = Report.get(id)
    raise Unauthorized unless @report.user == session.user
    @report.update_attributes(report)
  end

  def destroy(id)
    @report = Report.get(id)
    raise Unauthorized unless @report.user == session.user
    @report.destroy
  end
end
