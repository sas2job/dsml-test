admin = User.create!(email: 'admin@example.com', password: 'password', role: 'admin')
employee1 = User.create!(email: 'employee1@example.com', password: 'password', role: 'employee')
employee2 = User.create!(email: 'employee2@example.com', password: 'password', role: 'employee')

# pending → в ожидании
# approved → утверждено
# rejected → отклонено

LeaveRequest.create!(
  user: employee1,
  status: :pending,
  start_date: Date.today + 7.days,
  end_date: Date.today + 14.days,
  reason: 'Annual vacation'
)

LeaveRequest.create!(
  user: employee1,
  status: :approved,
  start_date: Date.today + 30.days,
  end_date: Date.today + 35.days,
  reason: 'Family event'
)

LeaveRequest.create!(
  user: employee2,
  status: :rejected,
  start_date: Date.today + 10.days,
  end_date: Date.today + 12.days,
  reason: 'Medical leave'
)

LeaveRequest.create!(
  user: employee2,
  status: :pending,
  start_date: Date.today + 5.days,
  end_date: Date.today + 10.days,
  reason: 'Conference attendance'
)