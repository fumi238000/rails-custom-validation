class User < ApplicationRecord
  has_many :group_users, dependent: :nullify
  has_many :groups, through: :group_users

  # enum
  enum position: {
    manager: 0,
    staff: 1,
  }
end
