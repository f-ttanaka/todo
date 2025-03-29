module TODO.Middleware (applyMiddlewares) where

import Network.Wai (Middleware)
import TODO.Middleware.Auth

applyMiddlewares :: Middleware
applyMiddlewares = authMiddleware
