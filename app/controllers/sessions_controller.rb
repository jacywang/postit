class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      if user.two_factor_auth?
        session[:pin] = true
        user.generate_pin!
        # send pin to twilio and twilio SMS
        redirect_to pin_path
      else    
        login_user(user)
      end
    else
      flash[:error] = "There were something wrong with your username or password."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil 
    flash[:notice] = "You've logged out!"
    redirect_to root_path
  end

  def pin
    access_denied if session[:pin].nil?
    if request.post?
      user = User.find_by(pin: params[:pin])
      if user 
        session[:pin] = nil
        user.update_column(:pin, nil)
        login_user(user)
      else
        flash[:error] = "The pin number you input is not correct."
        render :pin 
      end
    end
  end

  private
    def login_user(user)
      session[:user_id] = user.id 
      flash[:notice] = "You've logged in!"
      redirect_to root_path
    end
end
