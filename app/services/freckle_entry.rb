class FreckleEntry
  def initialize(record)
    @attrs = record
  end

  def copy_to(project)
    FreckleApi.instance.create_entry(@attrs.to_h.merge(
      project_id: project.id,
      source_url: @attrs.url
    ))
  end

  private

  def method_missing(method_sym, *args, &block)
    if @attrs.respond_to?(method_sym)
      @attrs[method_sym]
    else
      super
    end
  end
end
