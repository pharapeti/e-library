class StaticController < ApplicationController
  def index
    if !user_signed_in?
      redirect_to new_user_session_url
    elsif current_user.library_manager?
      redirect_to library_managers_dashboard_path
    elsif current_user.student?
      redirect_to students_dashboard_path
    elsif current_user.staff?
      redirect_to staff_dashboard_path
    end
  end
end