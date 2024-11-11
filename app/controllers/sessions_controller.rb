class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Вы успешно вошли в систему.'
    else
      flash[:alert] = 'Неверный email или пароль.'
      redirect_to '/login'
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to '/login', notice: 'Вы вышли из системы.'
  end
end
