User.create!(
  email: 'admin@t.t',
  password: 'password',
  password_confirmation: 'password',
  role: 'admin',
  name: 'Admin'
)

5.times do |i|
  User.create!(
    email: "t#{i + 1}@t.t",
    password: 'password',
    password_confirmation: 'password',
    role: 'employee',
    name: "User #{i + 1}"
  )
end

# pending → в ожидании
# approved → утверждено
# rejected → отклонено

# LeaveRequest.create!(
#   user: employee1,
#   status: :pending,
#   start_date: Date.today + 7.days,
#   end_date: Date.today + 14.days,
#   reason: 'Annual vacation'
# )

# LeaveRequest.create!(
#   user: employee1,
#   status: :approved,
#   start_date: Date.today + 30.days,
#   end_date: Date.today + 35.days,
#   reason: 'Family event'
# )

# LeaveRequest.create!(
#   user: employee2,
#   status: :rejected,
#   start_date: Date.today + 10.days,
#   end_date: Date.today + 12.days,
#   reason: 'Medical leave'
# )

# LeaveRequest.create!(
#   user: employee2,
#   status: :pending,
#   start_date: Date.today + 5.days,
#   end_date: Date.today + 10.days,
#   reason: 'Conference attendance'
# )
