require 'rails_helper'

RSpec.describe LeaveRequest, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:reason) }

    it 'validates inclusion of status in statuses' do
      expect(described_class.statuses.keys).to include('pending', 'approved', 'rejected')
    end
  end

  describe '#translated_status' do
    it 'returns the translated status' do
      leave_request = build(:leave_request, status: :pending)
      expect(leave_request.translated_status).to eq(I18n.t('activerecord.attributes.leave_request.statuses.pending'))
    end
  end

  describe 'validations' do
    it 'is valid with valid start_date and end_date' do
      leave_request = build(:leave_request, user:, start_date: Date.today, end_date: Date.today + 1)
      expect(leave_request).to be_valid
    end

    it 'is invalid if end_date is before start_date' do
      leave_request = build(:leave_request, user:, start_date: Date.today, end_date: Date.yesterday)
      expect(leave_request).to be_invalid
      expect(leave_request.errors[:end_date]).to include("can't be before the start date.")
    end
  end
end
