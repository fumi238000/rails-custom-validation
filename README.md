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
