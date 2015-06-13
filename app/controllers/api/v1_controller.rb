class Api::V1Controller < ApplicationController

  def register
    begin
      email = register_api_params[:email].downcase
      user = User.find_by_email(email)
      if user.blank?
        user = User.create(:email => email, :password => register_api_params[:password], :lat => register_api_params[:lat], :lng => register_api_params[:lng])
        render :json => user
      else
        user.update_attributes(:lng, register_api_params[:lng].to_f, :lat => register_api_params[:lat].to_f)
        render :json => user
      end
    rescue Exception => e
      render :json => "Something went wrong."
    end
  end

  def find_nearby
    begin
      user = User.find_by_auth_token(register_api_params[:auth_token])
      unless user.blank?
        users_nearby = User.find_users_nearby(user)
        render :json => users_nearby
      else
        render :json => "No such user found."
      end
    rescue Exception => e
      render :json => "Something went wrong."
    end
  end


  private


  def register_api_params
    params.permit(:username, :password, :email, :auth_token, :lng, :lat)
  end


end