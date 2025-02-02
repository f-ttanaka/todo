module TODO.Middlewares.Cors (setCors, Middleware) where

import Network.Wai (Middleware)
import Network.Wai.Middleware.Cors
import TODO.Prelude

setCors :: Middleware
setCors = cors (const $ Just policy)
  where
    policy =
      simpleCorsResourcePolicy
        { corsRequestHeaders = ["Content-Type"],
          corsMethods = ["GET", "POST", "DELETE", "PUT"]
        }
