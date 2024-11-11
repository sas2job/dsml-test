class User < ApplicationRecord
  has_secure_password

  enum role: { employee: 'employee', admin: 'admin' }

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
