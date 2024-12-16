require 'rails_helper'

RSpec.describe LeaveRequestsController, type: :controller do
  render_views

  include SessionHelpers

  let(:admin) { create(:user, role: 'admin') }
  let(:employee) { create(:user, role: 'employee') }
  let!(:leave_request) { create(:leave_request, user: employee) }

  describe 'GET #index' do
    context 'when logged in as an employee' do
      before do
        sign_in(employee)
        get :index
      end

      it 'assigns the leave requests for the current user' do
        expect(assigns(:leave_requests)).to eq([leave_request])
      end

      it 'renders the index page' do
        expect(response.status).to eq(200)
        expect(response.body).to include('Мои заявки')
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the login page' do
        get :index
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq('Пожалуйста, войдите в систему.')
      end
    end
  end

  describe 'GET #all_requests' do
    context 'when logged in as an admin' do
      before do
        sign_in(admin)
        get :all_requests
      end

      it 'assigns all leave requests' do
        expect(assigns(:leave_requests)).to eq(LeaveRequest.all)
      end

      it 'renders the all_requests page' do
        expect(response.status).to eq(200)
        expect(response.body).to include('Все заявки')
      end
    end

    context 'when logged in as an employee' do
      before { sign_in(employee) }

      it 'redirects to the root path with an alert' do
        get :all_requests
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Доступ запрещен')
      end
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      { leave_request: { start_date: Date.today, end_date: Date.today + 5, reason: 'Vacation' } }
    end

    let(:invalid_params) do
      { leave_request: { start_date: '', end_date: '', reason: '' } }
    end

    context 'when logged in as an employee' do
      before { sign_in(employee) }

      it 'creates a new leave request with valid params' do
        expect do
          post :create, params: valid_params
        end.to change(LeaveRequest, :count).by(1)
        expect(response).to redirect_to(leave_requests_path)
        expect(flash[:notice]).to eq('Заявка успешно создана.')
      end

      it 'does not create a leave request with invalid params' do
        expect do
          post :create, params: invalid_params
        end.not_to change(LeaveRequest, :count)
        expect(response.status).to eq(422)
        expect(response.body).to include('Создать заявку')
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        post :create, params: valid_params
        expect(response).to redirect_to('/login')
      end
    end
  end

  describe 'PATCH #update' do
    let(:valid_update_params) do
      { id: leave_request.id, leave_request: { reason: 'Updated Reason' } }
    end

    let(:invalid_update_params) do
      { id: leave_request.id, leave_request: { reason: '' } }
    end

    context 'when logged in as an admin' do
      before { sign_in(admin) }

      it 'updates the leave request with valid params' do
        patch :update, params: valid_update_params
        expect(leave_request.reload.reason).to eq('Updated Reason')
        expect(response).to redirect_to(all_requests_path)
        expect(flash[:notice]).to eq('Заявка успешно обновлена.')
      end

      it 'does not update the leave request with invalid params' do
        patch :update, params: invalid_update_params
        expect(response.status).to eq(422)
        expect(response.body).to include('Редактировать заявку')
      end
    end

    context 'when logged in as the owner' do
      before { sign_in(employee) }

      it 'updates their own leave request' do
        patch :update, params: valid_update_params
        expect(leave_request.reload.reason).to eq('Updated Reason')
        expect(response).to redirect_to(leave_requests_path)
        expect(flash[:notice]).to eq('Заявка успешно обновлена.')
      end
    end

    # context 'when logged in as another employee' do
    #   before { sign_in(other_employee) }
    #   it 'redirects to leave requests path with an alert' do
    #     patch :update, params: { id: leave_request.id, leave_request: { reason: 'Updated Reason' } }

    #     expect(response).to redirect_to(leave_requests_path)
    #     expect(flash[:alert]).to eq('У вас нет прав для выполнения этого действия.')
    #   end
    # end
  end
end
