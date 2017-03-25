module ContentfulHelpers
  def project_sort(projects)
    projects.sort_by { |id, project| project.releaseDate }
  end

  def sort_projects(projects)
    projects.sort do |a, b|
      b[1].releaseDate <=> a[1].releaseDate
    end
  end
end
