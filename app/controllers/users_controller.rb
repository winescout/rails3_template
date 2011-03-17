class UsersController < ApplicationController
  respond_to :json, :html
  layout false

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(params[:user])
    respond_with(@user)
  end

end
