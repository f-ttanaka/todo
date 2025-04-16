# Stack が含まれる Haskell の公式イメージを使う
# Debian 11 (Bullseye) ベースの Haskell イメージを使用
# buster-pgdg が使えなくなってしまった?ので bullseye を使う
# https://www.postgresql.org/message-id/Zqj_4nlZEqfbQ2aM%40msg.df7cb.de
FROM haskell:9.10.1-bullseye

# 作業ディレクトリの作成
WORKDIR /app

# Stack の設定をキャッシュするための最適化
COPY stack.yaml stack.yaml
COPY package.yaml package.yaml
COPY src src
COPY app app
COPY migrations migrations

# hasql を使うのに libpq-dev の ver 14 以上が必要だが、初期設定の apt だと ver 11 しか無い。
# なので Postgres のリポジトリから直接 libpq-dev を取得する。以下にある手順を参考にしている。
# https://www.postgresql.org/download/linux/debian/
RUN apt-get update \
    && apt-get install -y curl ca-certificates \
    && install -d /usr/share/postgresql-common/pgdg \
    && curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc \
    && sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt bullseye-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
    && apt-get update

RUN apt-get install -y libpq-dev

# Stack の依存関係をインストール
RUN stack setup && stack build --only-dependencies

# アプリをビルド
RUN stack build

# 実行ファイルをコピー
RUN cp $(stack path --local-install-root)/bin/api-exe /usr/local/bin/

# コンテナ起動時に API サーバーを実行
CMD ["api-exe"]