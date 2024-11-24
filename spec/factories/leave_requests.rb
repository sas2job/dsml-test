FactoryBot.define do
  factory :leave_request do
    association :user
    status { :pending }
    start_date { Date.today }
    end_date { Date.today + 5.days }
    reason { 'Vacation request' }
  end
end
