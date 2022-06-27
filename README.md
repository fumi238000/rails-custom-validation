# カスタムバリデーションを実装する

カスタムバリデーションをかける手順をまとめた。

## 参考資料

以下の参考資料をベースに作成

- [EachValidator クラスのカスタムバリデーション設定(Rails6/lib 以下読込)](https://blog.cloud-acct.com/posts/u-rails-custom-eachvalidator/)

## 1.事前準備
- [こちら](https://github.com/fumi238000/rails-custom-validation/edit/main/README.md#%E4%BA%8B%E5%89%8D%E6%BA%96%E5%82%99%E6%89%8B%E9%A0%86)


## 2.カスタムバリデーション実装手順

### 1.カスタムバリデーションのディレクトリを作成
命名は各自変更してください。

```shell
mkdir lib/validator && touch $_/group_user_validator.rb
```

- lib/validator/group_user_validator.rb

```rb
# group_user_validator.rb


class GroupUserValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # カスタムバリデーションを記述
    binding.pry
  end
end

```

### 2.使用したいモデルで読み込む
require を用いて、カスタムバリデーションを読み込む

```rb
# models/group_user.rb


require "validator/group_user_validator" # カスタムバリデーションを読み込む

class GroupUser < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :user, group_user: { allow_blank: true } #=> user_idにバリデーションをかける
end

```

読み込めているか、binding.pryを使用して確認すること。

### 3.カスタムバリデーションの記述
今回は、以下の制限の時、保存できないようにした。
1) ユーザーがstaffの時
2) 所有しているグループが`max_group_num`(今回は1つとした)より多い場合


```rb
# lib/validator/group_user_validator.rb

class GroupUserValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    max_group_num = 1

    if value.staff? && value.groups.count >= max_group_num
      record.errors.add(attribute, "スタッフの場合、#{max_group_num}つまでしか管理できません。")
    end
  end
end


```

最後に、保存ができないことを確認する

```shell

> rails c

user = User.find_by(name: "スタッフユーザー")

> group_user = GroupUser.create(group_id: Group.first.id, user_id: user.id)
  
  Group Load (0.5ms)  SELECT "groups".* FROM "groups" ORDER BY "groups"."id" ASC LIMIT $1  [["LIMIT", 1]]
  TRANSACTION (0.1ms)  BEGIN
  User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 2], ["LIMIT", 1]]
  Group Load (0.1ms)  SELECT "groups".* FROM "groups" WHERE "groups"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  Group Count (0.4ms)  SELECT COUNT(*) FROM "groups" INNER JOIN "group_users" ON "groups"."id" = "group_users"."group_id" WHERE "group_users"."user_id" = $1  [["user_id", 2]]
  TRANSACTION (0.1ms)  ROLLBACK
=> #<GroupUser:0x00000001438aa720 id: nil, user_id: 2, group_id: 1, created_at: nil, updated_at:...
#=> ロールバックが発生し、保存ができない

# エラーメッセージが格納されていることを確認
> group_user.errors.full_messages
=> ["User スタッフの場合、1つまでしか管理できません。"]
```



## 事前準備手順
### 1.アプリ作成

```shell
rails new cumstom-validate -d postgresql
```

### 2.テーブルを作成

```
rails g model User name:string position:integer
rails g model Group name:string
rails g model GroupUsers user:references group:references
```

- テーブルに制限を入れる
```rb
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end
```


```rb
class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end

```

```shell
rails db:create
rails db:migrate
```


### 3.テストデータを導入
以下を記述して、`rails db:seed`を実行する

```rb

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

```


## 4.関連付けとenumを実装
```rb
# user.rb

class User < ApplicationRecord
  # 関連付け
  has_many :group_users, dependent: :nullify
  has_many :groups, through: :group_users

  # enum
  enum position: {
    manager: 0,
    staff: 1
  }
end
```

```rb
class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
end

```

- 以下で取得できればOK
```shell
 User.first.groups
 Group.first.users
 User.staff
 User.manager
```


## 参考資料

- [EachValidator クラスのカスタムバリデーション設定(Rails6/lib 以下読込)](https://blog.cloud-acct.com/posts/u-rails-custom-eachvalidator/)

- [【Rails】errors.addって何？](https://qiita.com/yujiG/items/3e34e2e0e7b4120b0584)
- [Active Record(Railsのモデル) バリデーションまとめ](https://morizyun.github.io/ruby/active-record-validation.html#%E3%82%AA%E3%83%AA%E3%82%B8%E3%83%8A%E3%83%AB%E3%81%AE%E3%83%90%E3%83%AA%E3%83%87%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%AF%E3%83%A9%E3%82%B9%EF%BC%9Avalidates-with)
