class GroupUserValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      # カスタムバリデーションを記述
      binding.pry
    end
  end