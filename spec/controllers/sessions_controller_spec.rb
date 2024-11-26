require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user, email: 'test@example.com', password: 'password') }

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'logs in the user and redirects to the root path' do
        post :create, params: { email: user.email, password: 'password' }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Вы успешно вошли в систему.')
      end
    end

    context 'with invalid credentials' do
      it 'does not log in the user and redirects to login path' do
        post :create, params: { email: user.email, password: 'wrong_password' }
        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to('/login')
        expect(flash[:alert]).to eq('Неверный email или пароль.')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in(user)
    end

    it 'logs out the user and redirects to login path' do
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to('/login')
      expect(flash[:notice]).to eq('Вы вышли из системы.')
    end
  end
end
