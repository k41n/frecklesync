module ApplicationHelper
  def active_if_cond(cond)
    'active' if params[:condition] == cond
  end
end
