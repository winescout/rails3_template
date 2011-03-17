class PasswordsController < Devise::PasswordsController
  respond_to :html, :js
  def new
    @user = User.new
  end 

  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])
    if resource.errors.empty?
      set_flash_message :notice, :send_instructions
      render :status => 200, :json => flash.to_json
    else
      render :status => 422, :json => resource.errors.to_json
    end
  end

end
