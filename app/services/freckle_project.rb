class FreckleProject
  def initialize(record)
    @attrs = record
  end

  def entries(condition = nil)
    FreckleApi.instance.entries_for_project(@attrs.id, condition || {})
  end

  def self.all
    FreckleApi.instance.projects(per_page: 1000)
  end

  def self.internal
    all.select(&:internal?)
  end

  def self.by_name(name)
    all.find{ |x| x.name == name }
  end

  def internal?
    @attrs&.group&.name&.downcase == 'internal'
  end

  def to_h
    @attrs.to_h
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
