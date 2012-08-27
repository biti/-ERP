class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_partner

  def require_partner
    if session[:partner_id].blank?
      redirect_to :login and return
    end
    
    @current_partner = Partner.find_by_id session[:partner_id]
    
    unless @current_partner
      redirect_to :login and return
    end
    logger.info "current partner=========%s" % @current_partner.try(:login)
  end
  
end
