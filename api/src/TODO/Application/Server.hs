{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module TODO.Application.Server (serveApplication) where

import Servant
import TODO.Common.App
import TODO.Handler.Todo
import TODO.Middleware
import TODO.Prelude
import TODO.Type.Todo

type API =
  "api" :> "todo" :> Capture "userUuid" UUID :> Get '[JSON] [Todo]
    :<|> "api" :> "todo" :> Capture "userUuid" UUID :> ReqBody '[JSON] Text :> Post '[JSON] UUID
    :<|> "api" :> "todo" :> Capture "uuid" UUID :> Delete '[JSON] Int
    :<|> "api" :> "todo" :> "title" :> Capture "uuid" UUID :> Capture "title" Text :> Put '[JSON] NoContent
    :<|> "api" :> "todo" :> "state" :> Capture "uuid" UUID :> Put '[JSON] NoContent

server :: ServerT API App
server =
  getTodo
    :<|> postTodo
    :<|> deleteTodo
    :<|> updateTitle
    :<|> updateStatus

api :: Proxy API
api = Proxy

serveApplication :: Application
serveApplication = applyMiddlewares $ serve api $ hoistServer api (liftIO . runApp) server
