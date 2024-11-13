# pending → в ожидании
# approved → утверждено
# rejected → отклонено

# Создание администратора
admin = User.create!(
  email: 'admin@t.t',
  password: 'password',
  password_confirmation: 'password',
  role: 'admin',
  name: 'Admin'
)

# Создание сотрудников
employees = []
5.times do |i|
  employees << User.create!(
    email: "t#{i + 1}@t.t",
    password: 'password',
    password_confirmation: 'password',
    role: 'employee',
    name: "User #{i + 1}"
  )
end

# Создание заявок для сотрудников
LeaveRequest.create!(
  user: employees[0],
  status: :pending,
  start_date: Date.today + 7.days,
  end_date: Date.today + 14.days,
  reason: 'Annual vacation'
)

LeaveRequest.create!(
  user: employees[0],
  status: :approved,
  start_date: Date.today + 30.days,
  end_date: Date.today + 35.days,
  reason: 'Family event'
)

LeaveRequest.create!(
  user: employees[1],
  status: :rejected,
  start_date: Date.today + 10.days,
  end_date: Date.today + 12.days,
  reason: 'Medical leave'
)

LeaveRequest.create!(
  user: employees[1],
  status: :pending,
  start_date: Date.today + 5.days,
  end_date: Date.today + 10.days,
  reason: 'Conference attendance'
)
