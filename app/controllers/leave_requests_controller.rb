class LeaveRequestsController < ApplicationController
  before_action :set_leave_request, only: %i[edit update destroy]
  before_action :ensure_admin, only: [:all_requests]
  before_action :authenticate_user!, only: [:create]

  # Список заявок сотрудника
  def index
    if current_user
      @leave_requests = current_user.leave_requests.order(created_at: :desc)
      flash[:alert] = 'У вас нет заявок.' if @leave_requests.empty?
    else
      redirect_to login_path, alert: 'Пожалуйста, войдите в систему.'
    end
  end

  # Список всех заявок (только для администратора)
  def all_requests
    ensure_admin
    @leave_requests = LeaveRequest.all
  end

  def new
    @leave_request = current_user.leave_requests.build
  end

  def create
    @leave_request = current_user.leave_requests.build(leave_request_params)
    if @leave_request.save
      redirect_to leave_requests_path, notice: 'Заявка успешно создана.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    ensure_owner_or_admin
  end

  def update
    if current_user.admin?
      if @leave_request.update(leave_request_params)
        redirect_to all_requests_path, notice: 'Заявка успешно обновлена.'
      else
        render :edit, status: :unprocessable_entity
      end
    elsif @leave_request.update(leave_request_params)
      redirect_to leave_requests_path, notice: 'Заявка успешно обновлена.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    ensure_owner_or_admin
    @leave_request.destroy
    redirect_to leave_requests_path, notice: 'Заявка успешно удалена.'
  end

  private

  def set_leave_request
    @leave_request = LeaveRequest.find(params[:id])
  end

  def leave_request_params
    if current_user.admin?
      params.require(:leave_request).permit(:start_date, :end_date, :reason, :status)
    else
      params.require(:leave_request).permit(:start_date, :end_date, :reason)
    end
  end

  def ensure_owner_or_admin
    return if current_user.role == 'admin' || @leave_request.user == current_user

    redirect_to leave_requests_path, alert: 'У вас нет прав для выполнения этого действия.'
  end

  def ensure_admin
    redirect_to root_path, alert: 'Доступ запрещен' unless current_user&.role == 'admin'
  end

  def authenticate_user!
    redirect_to login_path, alert: 'Пожалуйста, войдите в систему.' unless current_user
  end
end
