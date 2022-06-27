require "validator/group_user_validator"

class GroupUser < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :user, group_user: { allow_blank: true }
end
