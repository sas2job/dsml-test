require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:leave_requests).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:name) }
  end

  describe 'enums' do
    it do
      should define_enum_for(:role)
        .with_values(employee: 'employee', admin: 'admin')
        .backed_by_column_of_type(:string)
    end
  end

  describe 'role behavior' do
    let(:employee_user) { create(:user, role: 'employee') }
    let(:admin_user) { create(:user, role: 'admin') }

    it 'allows a user to have the role of employee' do
      expect(employee_user.role).to eq('employee')
      expect(employee_user).to be_employee
      expect(employee_user.admin?).to be_falsey
    end

    it 'allows a user to have the role of admin' do
      expect(admin_user.role).to eq('admin')
      expect(admin_user).to be_admin
      expect(admin_user.employee?).to be_falsey
    end
  end
end
