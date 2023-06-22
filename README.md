###  ユーザ (user)

| カラム名        | データ型    |
| --------------- | ----------- |
| id              | integer     |
| name            | string      |
| email           | string      |
| password_digest | string      |
| created_at      | timestamp   |
| updated_at      | timestamp   |
| admin           | boolean     |


### タスク (task)

| カラム名 | データ型 |
| -------- | -------- |
| id       | integer  |
| user_id  | bigint   |
| title    | string   |
| detail   | text     |
| expired_at | date     |
| priority | string   |
| status   | string   |
|created_at| timestamp|
|updated_at| timestamp|

### タスクラベル (task_label)

| カラム   | データ型  |
| ---------- | --------- |
| id         | integer   |
| task_id    | integer   |
| label_id   | integer   |
| created_at | timestamp |
| updated_at | timestamp |

### ラベル (label)

| カラム名 | データ型 |
| -------- | -------- |
| id       | integer  |
| name     | string   |

# herokuへのデプロイ方法
1. config/route.rbでrootのルーティング設定
2. herokuにログインをする
   $heroku login
3. herokuに新規アプリを作成する
   $heroku create
4. herokuが紐づいているか確認
   $git remote -v
5. 以下がいつもエラーが出るので設定しておく
   $heroku stack:set heroku-20
   $heroku stack
   $bundle lock --add-platform x86_64-linux
   package.jsonにNode.jsのバージョンを16.xに指定する
6. gitへコミット
   $git add .
   $git commit -m ""
7. herokuへのデプロイ
   $git push heroku main
8. DBのマイグレート
   $heroku run rails db:migrate