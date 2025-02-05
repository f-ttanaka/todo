module TODO.Middleware (applyMiddlewares) where

import Network.Wai (Middleware)
import TODO.Middleware.Cors

applyMiddlewares :: Middleware
applyMiddlewares = setCors
