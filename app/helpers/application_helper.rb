module ApplicationHelper

  def display_time(dt)
    dt = dt.in_time_zone(current_user.time_zone) if logged_in? && !current_user.time_zone.blank?
    dt.strftime("%m/%d/%Y %l:%M%p %Z")
  end
end
