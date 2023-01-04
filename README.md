# Todo アプリケーション作成練習
Todo 管理 Web アプリケーション (SPA）の作成練習。
UI と デザインは MDN の Getting started with React のものを模倣。
(https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/React_getting_started)

アーキテクチャ構成はフロントエンド、バックエンドAPI、RDB となっている。
バックエンドAPI は Haskell の Servant (https://docs.servant.dev/en/stable/) を使用して作成。
使用するポート番号は以下:
1. フロントエンド : 3000
1. バックエンドAPI : 3100
1. RDB : 5430

## ツール
使用するには以下が必要。
- フロントエンド
  - Next.js (https://nextjs.org/),
  パッケージ管理システムは npm を使用
- バックエンドAPI
  - Haskell のプロジェクト管理ツール stack ver 2.9.1 (https://docs.haskellstack.org/en/stable/), Haskell のコンパイラ ghc は version 9.2.5
  - libpq (https://www.postgresql.org/docs/8.1/libpq.html) 
    - postgresql-libs (https://www.archlinux.jp/packages/extra/x86_64/postgresql-libs/) をインストールすると一緒に手に入ります。
    - libpq/bin に PATH を通しておいてください。
- RDBMS（docker で使用することを前提とする。）
  - postgres 14-alpine (https://hub.docker.com/_/postgres)

## ビルド & 使用手順
1. todo/docker_postgres へ移動して以下を順次実行してコンテナ内の postgreSQL へ接続する。
```
docker-compose up -d         # コンテナ起動
docker-compose exec db bash  # コンテナに入る
psql -U root                 # postgreSQL に接続
```
2. 以下のクエリを実行して「todo」という名前のデータベースを作る。
```
CREATE DATABASE todo;
```
3. todo/api へ移動して以下を実行。
  ```
  stack build
  stack exec api-exe
  ```
4. 別のコマンドラインウィンドウを開き、todo/frontend へ移動して以下を実行。
  ```
  npm run dev
  ```
5. http://localhost:3000/ をブラウザ上で開くと Todo アプリが使用可能。

## UI
### 投稿フォーム
  - 文字を入力し、「Add」ボタンを押すと新規 Todo が追加される。
  - 文字数は 1 以上 50 以下でなければならない。
### Todo
  - タイトルの左のチェックの 有/無 は 完了/未了 を表す。「Change State」ボタンで状態を切り替えることができる。
  - 「Edit」ボタンを押すと編集フォームに切り替わる。投稿フォームと同様に 1 以上 50 以下の文字数を入れるとタイトルを変更できる。
  - 「Delete」ボタンを押すと Todo が削除される。
### フィルター
押されたボタンの状態で表示される Todo が変わる。
  - 「All」の時は全ての Todo
  - 「Active」は未了（チェックなし）の Todo
  - 「Completed」は完了（チェックあり）の Todo
