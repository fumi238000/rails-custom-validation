# 2つのタイプのユーザーを作成する
# マネージャー
User.find_or_create_by!(name: "マネージャーユーザー") do |u|
  u.name = "マネージャーユーザー"
  u.position = 0
  #   u.position =  "manager" # 確認する
end

# スタッフ
User.find_or_create_by!(name: "スタッフユーザー") do |u|
  u.name = "スタッフユーザー"
  u.position = 1
  #   u.position =  "staff" # 確認する
end

# 5つのグループを作成する
GROUP_NUM = 5

GROUP_NUM.times do |i|
  Group.find_or_create_by!(name: "グループ#{i + 1}")
end

# ユーザーにグループを持たせる(表現)
Group.all.each do |group|
  # マネージャー
  manager_user = User.find_by(name: "マネージャーユーザー")
  GroupUser.find_or_create_by!(group_id: group.id, user_id: manager_user.id)

  # スタッフ
  staff_user = User.find_by(name: "スタッフユーザー")
  GroupUser.find_or_create_by!(group_id: group.id, user_id: staff_user.id)
end

# # スタッフ
# staff_user = User.find_by(name: "スタッフユーザー")
# GroupUser.create(group_id: Group.first.id, user_id: staff_user.id)
