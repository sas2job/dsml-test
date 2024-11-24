FactoryBot.define do
  factory :user do
    name { 'Test User' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password123' }
  end
end
