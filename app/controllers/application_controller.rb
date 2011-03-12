class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout

  # Override the default devise signin/signout process
  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope      = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    #redirect_to stored_location_for(scope) || after_sign_in_path_for(resource)
    render :json => {:status => :signed_in}
  end

  private

  def layout
    if params[:controller] == "welcome"
      return "anonymous"
    else
      # session and user are served xhr, so no layout
      devise_controller? ? false : "application"
    end
  end
end
