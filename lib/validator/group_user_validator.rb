class GroupUserValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    max_group_num = 1

    if value.staff? && value.groups.count >= max_group_num
      record.errors.add(attribute, "スタッフの場合、#{max_group_num}つまでしか管理できません。")
    end
  end
end
