# === Base stage with shared setup ===
# Stack が含まれる Haskell の公式イメージを使う
# Debian 11 (Bullseye) ベースの Haskell イメージを使用
# buster-pgdg が使えなくなってしまった?ので bullseye を使う
# https://www.postgresql.org/message-id/Zqj_4nlZEqfbQ2aM%40msg.df7cb.de
FROM arm64v8/haskell:9.10.1-bullseye as base

# hasql を使うのに libpq-dev の ver 14 以上が必要だが、初期設定の apt だと ver 11 しか無い。
# なので Postgres のリポジトリから直接 libpq-dev を取得する。以下にある手順を参考にしている。
# https://www.postgresql.org/download/linux/debian/
RUN apt-get update \
    && apt-get install -y curl ca-certificates \
    && install -d /usr/share/postgresql-common/pgdg \
    && curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc \
    && sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt bullseye-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
    && apt-get update \
    && apt-get install -y libpq-dev

# 作業ディレクトリの作成
WORKDIR /app

# === Dependencies build stage ===
FROM base AS deps

# Stack の依存関係をインストール
COPY stack.yaml package.yaml ./
RUN stack setup && stack build --only-dependencies

# === Application build stage ===
FROM base AS build

# dependencies のビルド生成物を持ってくる
COPY --from=deps /root/.stack /root/.stack
COPY --from=deps /app/.stack-work /app/.stack-work

# アプリをビルド
COPY . .
RUN stack build

# 実行ファイルをコピー
RUN cp $(stack path --local-install-root)/bin/api-exe /usr/local/bin/

# コンテナ起動時に API サーバーを実行
CMD ["api-exe"]