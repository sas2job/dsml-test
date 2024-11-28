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
end
