class UsersController < ApplicationController
  before_action :set_user, except: [:new, :create]
  before_action :require_same_user, only: [:edit, :create]

  def new
    @user = User.new
  end

  def show
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "New user was just created."
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "New profile was saved."
      redirect_to user_path
    else
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :password, :time_zone)
    end

    def set_user
      @user = User.find_by(slug: params[:id])
    end

    def require_same_user
      if current_user != @user 
        flash[:error] = "This action is not allowed."
        redirect_to :root_path
      end
    end
end