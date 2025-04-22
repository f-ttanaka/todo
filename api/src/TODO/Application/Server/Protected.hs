{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

module TODO.Application.Server.Protected
  ( authHandler,
    protectedServer,
    ProtectedRoutes,
  )
where

import Data.List (lookup)
import Servant.Server.Experimental.Auth
import TODO.Application.Auth.Session
import TODO.Application.Handler.Todo
import TODO.Application.Server.Internal
import TODO.Data.Todo
import Web.Cookie

type instance AuthServerData (AuthProtect "session-cookie") = UUID

authHandler :: Env -> AuthHandler Request UUID
authHandler env = mkAuthHandler $ \req -> do
  let cookies = maybe [] parseCookies (lookup "cookie" (requestHeaders req))
  case lookup "session_id" cookies of
    Nothing -> throwError err401
    Just sid -> getUserInfoFromSession (redisConn env) sid

type ProtectedRoutes =
  AuthProtect "session-cookie"
    :> "api"
    :> "todo"
    :> Get '[JSON] [Todo]
    :<|> AuthProtect "session-cookie"
    :> "api"
    :> "todo"
    :> ReqBody '[JSON] Text
    :> Post '[JSON] NoContent
    :<|> AuthProtect "session-cookie"
    :> "api"
    :> "todo"
    :> Capture "uuid" UUID
    :> Delete '[JSON] Int
    :<|> AuthProtect "session-cookie"
    :> "api"
    :> "todo"
    :> "title"
    :> Capture "uuid" UUID
    :> Capture "title" Text
    :> Put '[JSON] NoContent
    :<|> AuthProtect "session-cookie"
    :> "api"
    :> "todo"
    :> "state"
    :> Capture "uuid" UUID
    :> Put '[JSON] NoContent

protectedServer :: ServerT ProtectedRoutes App
protectedServer =
  getTodo
    :<|> postTodo
    :<|> deleteTodo
    :<|> updateTitle
    :<|> updateStatus
