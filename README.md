# カスタムバリデーションを実装する
カスタムバリデーションをかける手順をまとめた。

## 参考資料
以下の参考資料をベースに作成
- [EachValidator クラスのカスタムバリデーション設定(Rails6/lib 以下読込)](https://blog.cloud-acct.com/posts/u-rails-custom-eachvalidator/)



## 事前準備

### 1.アプリ作成
```shell
rails new . -d postgresql
```

### 2.テーブルを作成
```
rails g model User name:string position: integer
rails g model Group name:string
rails g model GroupUsers user:references group:references
```

### 3.テストデータを導入
```rb

# seedをここに記載

```

現在は、以下のようなデータが保存される
```
ここに記載
```




## カスタムバリデーションを用いて、達成したい課題

- users の position が staff の時、 group_user に 1 つしか保存できないようにする制限をかける


## カスタムバリデーションを作成する

### 1.カスタムバリデーションのディレクトリを作成

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

