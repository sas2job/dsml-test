require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:admin) { create(:user, role: 'admin') }
  let(:employee) { create(:user, role: 'employee') }
  let(:valid_attributes) { { name: 'Test User', email: 'test@example.com', password: 'password', role: 'employee' } }
  let(:invalid_attributes) { { name: '', email: '', password: '', role: '' } }

  before { sign_in(admin) }

  describe 'GET #new' do
    it 'returns a 200 status code' do
      get :new
      expect(response.status).to eq(200)
    end

    it 'creates a new user instance' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'GET #index' do
    it 'returns a 200 status code' do
      get :index
      expect(response.status).to eq(200)
    end

    it 'returns a list of users' do
      get :index
      expect(assigns(:users)).to eq([admin, employee])
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new user and redirects to root path' do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Пользователь успешно создан.')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new user and renders the new template' do
        expect do
          post :create, params: { user: invalid_attributes }
        end.not_to change(User, :count)
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET #edit' do
    it 'returns a 200 status code' do
      get :edit, params: { id: admin.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the user and redirects to users path' do
        patch :update, params: { id: admin.id, user: { name: 'Updated Name' } }
        admin.reload
        expect(admin.name).to eq('Updated Name')
        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to eq('Пользователь успешно обновлен.')
      end
    end

    context 'with invalid attributes' do
      it 'does not update the user and returns status 422' do
        patch :update, params: { id: admin.id, user: { name: '' } }
        admin.reload
        expect(admin.name).not_to eq('')
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the user and redirects to root path' do
      expect do
        delete :destroy, params: { id: admin.id }
      end.to change(User, :count).by(-1)
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Пользователь удален.')
    end
  end
end
