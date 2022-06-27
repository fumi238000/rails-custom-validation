# README

## 手順

```shell
# アプリ作成
rails new . -d postgresql

# テーブルを作成
rails g model User name:string position: integer
rails g model Group name:string
rails g model GroupUsers user:references group:references
# 制限をかける

# テストデータを導入
# user
user の position が manager
user の position が staffe

# group
適当に5つ

# groupusers
user の position が manager に 5つ付与
user の position が staff に 5つ付与

# これで、ひとまずseedが通る

```

- enum or 文字列で position を保存

- 制限をかけていない場合、保存される
  user の position が manager
  user の position が staffe

## 課題

- users の position が staff の時、 group_user に 1 つしか保存できない
- カスタムバリデーションをかけること

## カスタムバリデーションを作成する

### カスタムバリデーションのディレクトリを作成

```shell
mkdir lib/validator && touch $_/group_user_validator.rb
```

- lib/validator/group_user_validator.rb

```rb
# group_user_validator.rb
class GroupUserValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # カスタムバリデーションを記述
  end
end

```

- models/group_user.rb から読み込み

```rb
require "validator/group_user_validator" # カスタムバリデーションを読み込む

class GroupUser < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :user, email: { allow_blank: true }
end

```

- 試しに読み込めているか確認した

```
> GroupUser.create(user_id: 1, group_id: 3)
  TRANSACTION (0.2ms)  BEGIN
  User Load (0.6ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  Group Load (0.5ms)  SELECT "groups".* FROM "groups" WHERE "groups"."id" = $1 LIMIT $2  [["id", 3], ["LIMIT", 1]]

From: /Users/fumiya/Desktop/rails-custom-validation/lib/validator/group_user_validator.rb:5 GroupUserValidator#validate_each:

    2: def validate_each(record, attribute, value)
    3:   # カスタムバリデーションを記述
    4:   binding.pry
 => 5: end

[1] pry(#<GroupUserValidator>)>
```

## テーブル設計

```shell
これ、何かでテーブル設計できたはず

groups
id
name

users
id
name
position

group_users
id
group_id
user_id

```

## 要件

- ユーザーのタイプが admin だった場合、複数登録ができる
- ユーザーのタイプが user だった場合、1 つしか登録できない

# 最後に rubocop を入れておくこと

## 参考資料

- [EachValidator クラスのカスタムバリデーション設定(Rails6/lib 以下読込)](https://blog.cloud-acct.com/posts/u-rails-custom-eachvalidator/)

- https://qiita.com/yujiG/items/3e34e2e0e7b4120b0584
- https://morizyun.github.io/ruby/active-record-validation.html#%E3%82%AA%E3%83%AA%E3%82%B8%E3%83%8A%E3%83%AB%E3%81%AE%E3%83%90%E3%83%AA%E3%83%87%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%AF%E3%83%A9%E3%82%B9%EF%BC%9Avalidates-with
