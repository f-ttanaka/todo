{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

module TODO.Application.Server (serveApplication) where

import qualified Database.Redis as Redis
import Network.Wai
import Servant
import Servant.Server.Experimental.Auth
import TODO.Common.App
import TODO.Handler.Session
import TODO.Handler.Todo
import TODO.Handler.User
import TODO.Prelude hiding (Handler)
import TODO.Type.Todo
import TODO.Type.User
import Web.Cookie

type APIPrefix = "api"

type ProtectedRoutes =
  AuthProtect "session-cookie" :> APIPrefix :> "todo" :> Get '[JSON] [Todo]
    :<|> AuthProtect "session-cookie" :> APIPrefix :> "todo" :> ReqBody '[JSON] Text :> Post '[JSON] NoContent
    :<|> AuthProtect "session-cookie" :> APIPrefix :> "todo" :> Capture "uuid" UUID :> Delete '[JSON] Int
    :<|> AuthProtect "session-cookie" :> APIPrefix :> "todo" :> "title" :> Capture "uuid" UUID :> Capture "title" Text :> Put '[JSON] NoContent
    :<|> AuthProtect "session-cookie" :> APIPrefix :> "todo" :> "state" :> Capture "uuid" UUID :> Put '[JSON] NoContent

type instance AuthServerData (AuthProtect "session-cookie") = UUID

serverForTODO :: ServerT ProtectedRoutes App
serverForTODO =
  getTodo
    :<|> postTodo
    :<|> deleteTodo
    :<|> updateTitle
    :<|> updateStatus

type UnprotectedRoutes =
  APIPrefix :> "login" :> ReqBody '[JSON] UserResigter :> Post '[JSON] (Headers '[Header "Set-Cookie" SetCookie] NoContent)
    :<|> APIPrefix :> "user" :> ReqBody '[JSON] UserResigter :> Post '[JSON] NoContent

type APIRoutes =
  ProtectedRoutes
    :<|> UnprotectedRoutes

server :: ServerT APIRoutes App
server =
  serverForTODO
    :<|> login
    :<|> post

handleApp :: Env -> App a -> Handler a
handleApp env action = do
  result <- liftIO $ try $ runApp env action
  case result of
    Left e -> do
      -- ログ出力（必要なら env にロガーを組み込むとよい）
      liftIO $ putStrLn ("[ERROR] " ++ displayException e)
      throwError e
    Right val -> return val

authHandler :: Redis.Connection -> AuthHandler Request UUID
authHandler rc = mkAuthHandler $ \req -> do
  let cookies = maybe [] parseCookies (lookup "cookie" (requestHeaders req))
  case lookup "session_id" cookies of
    Nothing -> throwError err401
    Just sid -> getUserInfoFromSession rc sid

serveApplication :: Env -> Application
serveApplication env =
  let context = authHandler (redisConn env) :. EmptyContext
   in serveWithContextT (Proxy :: Proxy APIRoutes) context (handleApp env) server
