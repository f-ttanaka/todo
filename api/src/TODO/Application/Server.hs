{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module TODO.Application.Server (serveApplication) where

import Network.Wai
import Servant
import Servant.Auth.Server
import TODO.Common.App
import TODO.Handler.Todo
import TODO.Handler.User
import TODO.Middleware
import TODO.Middleware.Cors
import TODO.Prelude
import TODO.Type.Todo
import TODO.Type.User (UserResigter)

type TODOAPIRoutes =
  "api" :> "todo" :> Capture "userUuid" UUID :> Get '[JSON] [Todo]
    :<|> "api" :> "todo" :> Capture "userUuid" UUID :> ReqBody '[JSON] Text :> Post '[JSON] UUID
    :<|> "api" :> "todo" :> Capture "uuid" UUID :> Delete '[JSON] Int
    :<|> "api" :> "todo" :> "title" :> Capture "uuid" UUID :> Capture "title" Text :> Put '[JSON] NoContent
    :<|> "api" :> "todo" :> "state" :> Capture "uuid" UUID :> Put '[JSON] NoContent

serverForTODO :: ServerT TODOAPIRoutes App
serverForTODO =
  getTodo
    :<|> postTodo
    :<|> deleteTodo
    :<|> updateTitle
    :<|> updateStatus

type UserAPIRoutes =
  "api" :> "login" :> ReqBody '[JSON] UserResigter :> Post '[JSON] (Headers '[Header "Set-Cookie" SetCookie] UUID)

serverForUser :: ServerT UserAPIRoutes App
serverForUser = login

type APIRoutes =
  TODOAPIRoutes
    :<|> UserAPIRoutes

server :: ServerT APIRoutes App
server =
  serverForTODO
    :<|> serverForUser

api :: Proxy APIRoutes
api = Proxy

serveApplication :: Application
serveApplication req res =
  serve' req res
  where
    mw = case requestMethod req of
      "POST" | pathInfo req == ["api", "login"] -> setCors
      _ -> applyMiddlewares
    serve' = mw $ serve api $ hoistServer api (liftIO . runApp) server
