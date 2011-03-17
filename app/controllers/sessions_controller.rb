class SessionsController < Devise::SessionsController
  respond_to :html, :js
   # POST /resource/sign_in
  def create
    resource = warden.authenticate!(:scope => resource_name)
    sign_in(resource_name, resource)
    respond_with resource, :location => redirect_location(resource_name, resource)
  end
end

