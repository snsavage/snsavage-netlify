module ContentfulHelpers
  def sort_projects(projects)
    projects.sort do |a, b|
      b[1].releaseDate <=> a[1].releaseDate
    end
  end
end
