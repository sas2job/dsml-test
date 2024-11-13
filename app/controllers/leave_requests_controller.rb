class LeaveRequestsController < ApplicationController
  before_action :set_leave_request, only: %i[edit update destroy]
  before_action :ensure_admin, only: [:all_requests]

  # Список заявок сотрудника
  def index
    @leave_requests = current_user.leave_requests.order(created_at: :desc)
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
    ensure_owner_or_admin
    if @leave_request.update(leave_request_params)
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
    params.require(:leave_request).permit(:start_date, :end_date, :reason, :status)
  end

  def ensure_admin_or_owner
    return if current_user.role == 'admin' || @leave_request.user == current_user

    redirect_to leave_requests_path, alert: 'У вас нет прав для выполнения этого действия.'
  end

  def ensure_admin
    redirect_to root_path, alert: 'Доступ запрещен' unless current_user&.role == 'admin'
  end
end