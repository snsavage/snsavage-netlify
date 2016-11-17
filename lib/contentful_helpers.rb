module ContentfulHelpers
  def projects
    data.portfolio.project
  end

  def odd?
    data.portfolio.project.count.odd?
  end
end
