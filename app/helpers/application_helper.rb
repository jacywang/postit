module ApplicationHelper

  def display_time(dt)
    dt.strftime("%m/%d/%Y %l:%M%p %Z")
  end
end
