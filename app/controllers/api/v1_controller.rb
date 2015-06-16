class Api::V1Controller < ApplicationController

  def register
    begin
      email = register_api_params[:email].downcase
      user = User.find_by_email(email)
      if user.blank?
        user = User.create(:email => email, :password => register_api_params[:password], :lat => register_api_params[:lat], :lng => register_api_params[:lng])
        render :json => user
      else
        update_position(user)
        render :json => user
      end
    rescue Exception => e
      render :json => "Something went wrong."
    end
  end

  def find_nearby
    # begin
      user = User.find_by_auth_token(register_api_params[:auth_token])
      unless user.blank?
        users_nearby = User.new.find_users_nearby(user)
        render :json => users_nearby
      else
        render :json => "No such user found."
      end
    # rescue Exception => e
    #   render :json => "Something went wrong."
    # end
  end


  private

  def update_position(user)
    user.update_attribute('lng', register_api_params[:lng].to_f)
    user.update_attribute('lat', register_api_params[:lat].to_f)
  end

  def register_api_params
    params.permit(:username, :password, :email, :auth_token, :lng, :lat)
  end


end