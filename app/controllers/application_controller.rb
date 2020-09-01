class ApplicationController < ActionController::Base
  %i[student staff library_manager].each do |type|
    define_method "require_#{type}" do
      require_user_type type
    end
  end

  private

  def require_user_type(type)
    return if user_signed_in? && current_user.public_send("#{type}?")

    session[:return_to] = request.url unless action_name == 'sign_in'
    deny_access new_user_session_path
  end

  def deny_access(path)
    error = "Sorry, you're not allowed to view the page you requested."
    respond_to do |format|
      format.json { render json: { error: error }, status: :unauthorized }
      format.all { redirect_to path, notice: error }
    end
  end
end
