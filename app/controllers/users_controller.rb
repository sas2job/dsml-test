class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]
  # before_action :authenticate_user!, except: [:new, :create]
  before_action :ensure_admin, only: %i[index edit update]

  def new
    @user = User.new
  end

  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Пользователь успешно создан.'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path, notice: 'Пользователь успешно обновлен.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path, notice: 'Пользователь удален.'
  end

  private

  def ensure_admin
    redirect_to root_path, alert: 'Доступ запрещен' unless current_user&.role == 'admin'
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
