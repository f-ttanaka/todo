module TODO.Middleware.Cors (setCors) where

import Network.Wai (Middleware)
import Network.Wai.Middleware.Cors
import TODO.Prelude

setCors :: Middleware
setCors = cors (const $ Just policy)
  where
    policy =
      simpleCorsResourcePolicy
        { corsOrigins = Just (["http://localhost:5173"], True),
          corsRequestHeaders = ["Content-Type", "Cookie"],
          corsMethods = ["GET", "POST", "DELETE", "PUT"],
          corsExposedHeaders = Just ["Set-Cookie"], -- ブラウザに公開するヘッダー
          corsRequireOrigin = False -- `credentials: "include"` を有効にする
          -- corsCredentials = True -- クッキーを有効にする
        }
