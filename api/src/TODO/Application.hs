{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module TODO.Application (application) where

import Servant
import TODO.Handler.Todo
import TODO.Middleware.Cors (Middleware, setCors)
import TODO.Prelude
import TODO.Type.Todo (Todo, UUID)

type API =
  "api" :> "todo" :> Capture "title" Text :> Post '[JSON] UUID
    :<|> "api" :> "todo" :> Get '[JSON] [Todo]
    :<|> "api" :> "todo" :> Capture "uuid" UUID :> Delete '[JSON] Int
    :<|> "api" :> "todo" :> "title" :> Capture "uuid" UUID :> Capture "title" Text :> Put '[JSON] NoContent
    :<|> "api" :> "todo" :> "state" :> Capture "uuid" UUID :> Put '[JSON] NoContent

server :: Server API
server =
  postTodo
    :<|> getTodo
    :<|> deleteTodo
    :<|> updateTitle
    :<|> updateStatus

api :: Proxy API
api = Proxy

applyMiddlewares :: Middleware
applyMiddlewares = setCors

application :: Application
application = applyMiddlewares $ serve api server
