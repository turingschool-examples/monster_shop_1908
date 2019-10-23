class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true

  enum role: %w(default merchant_employee merchant_admin site_admin)
end
