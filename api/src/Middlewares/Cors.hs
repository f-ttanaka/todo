module Middlewares.Cors (setCors, Middleware) where

import Network.Wai (Middleware)
import Network.Wai.Middleware.Cors

setCors :: Middleware
setCors = cors (const $ Just policy)
  where
    policy = simpleCorsResourcePolicy
      { corsRequestHeaders = ["Content-Type"]
      , corsMethods = ["GET", "POST", "DELETE", "PUT"] }