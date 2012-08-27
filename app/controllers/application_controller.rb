class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_user, :check_init

  def require_user
    if session[:user_id].blank?
      redirect_to :login and return
    end
    
    @current_user = User.find_by_id session[:user_id]
    
    unless @current_user
      redirect_to :login and return
    end
    logger.info "user=========%s" % @current_user.try(:username)

    logger.debug "path=====%s" % request.fullpath
  end
  
  def check_init
    case @current_user.setting.status
    when 'new_user'
      redirect_to :init_step_one and return
    when 'binded'
      redirect_to :init_step_two and return
    end
  end

end
