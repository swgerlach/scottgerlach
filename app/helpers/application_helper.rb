module ApplicationHelper
  def current_url
    request.original_url
  end

  def current_path
    request.path
  end
end
