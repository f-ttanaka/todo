module TODO.Middleware (applyMiddlewares) where

import Network.Wai (Middleware)
import TODO.Middleware.Auth
import TODO.Middleware.Cors
import TODO.Prelude ((.))

applyMiddlewares :: Middleware
applyMiddlewares =
  setCors
    . authMiddleware
