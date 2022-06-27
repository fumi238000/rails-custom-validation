class GroupUserValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    max_group_num = 1

    record.errors.add(attribute, "スタッフの場合、#{max_group_num}つまでしか管理できません。") if value.staff? && value.groups.count >= max_group_num
  end
end
