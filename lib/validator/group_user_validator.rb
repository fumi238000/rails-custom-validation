class GroupUserValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      max_staff_num = 1
      if value.staff? && value.groups.count <= max_staff_num
        binding.pry
        # too_longを修正予定
        # record.errors.add(attribute, :too_long, count: max)
      end
    end
  end