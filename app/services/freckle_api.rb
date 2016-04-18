require 'freckle'

# Provides interaction with Freckle API
class FreckleApi
  include Singleton

  def projects
    wrap connection.get_projects
  end

  def entries_for_project(id, condition)
    wrap_entries connection.get_project_entries(
      id,
      build_extra_params(condition)
    )
  end

  def create_entry(params)
    connection.create_entry params
  end

  private

  def build_extra_params(condition = {})
    ret = { per_page: 1000 }
    case condition
    when :today then ret.merge(from: Time.zone.now.strftime('%Y-%m-%d'))
    end
  end

  def wrap(project_records)
    project_records.map { |x| FreckleProject.new(x) }
  end

  def wrap_entries(entries_records)
    entries_records.map { |x| FreckleEntry.new(x) }
  end

  def connection
    @connection ||= Freckle::Client.new(token: ENV['FRECKLE_ACCESS_TOKEN'])
  end
end
