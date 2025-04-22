{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

module TODO.Application.Server (serveApplication) where

import Data.List (lookup)
import Lucid (Html)
import Network.Wai
import Servant
import Servant.HTML.Lucid (HTML)
import Servant.Server.Experimental.Auth
import TODO.Admin.Index
import TODO.Common.App
import qualified TODO.Handler.Admin.User as H.Admin.U
import TODO.Handler.Session
import TODO.Handler.Todo
import TODO.Handler.User
import TODO.Prelude
import TODO.Type.Todo
import TODO.Type.User
import Web.Cookie

type APIPrefix = "api"

type instance AuthServerData (AuthProtect "session-cookie") = UUID

type ProtectedRoutes =
  AuthProtect "session-cookie" :> APIPrefix :> "todo" :> Get '[JSON] [Todo]
    :<|> AuthProtect "session-cookie" :> APIPrefix :> "todo" :> ReqBody '[JSON] Text :> Post '[JSON] NoContent
    :<|> AuthProtect "session-cookie" :> APIPrefix :> "todo" :> Capture "uuid" UUID :> Delete '[JSON] Int
    :<|> AuthProtect "session-cookie" :> APIPrefix :> "todo" :> "title" :> Capture "uuid" UUID :> Capture "title" Text :> Put '[JSON] NoContent
    :<|> AuthProtect "session-cookie" :> APIPrefix :> "todo" :> "state" :> Capture "uuid" UUID :> Put '[JSON] NoContent

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

type AdminRoutes =
  "admin" :> Get '[HTML] (Html ())
    :<|> "admin" :> "users" :> Get '[HTML] (Html ())

adminServer :: ServerT AdminRoutes App
adminServer =
  return adminIndex
    :<|> H.Admin.U.index

type APIRoutes =
  AdminRoutes
    :<|> ProtectedRoutes
    :<|> UnprotectedRoutes

server :: ServerT APIRoutes App
server =
  adminServer
    :<|> serverForTODO
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

authHandler :: Env -> AuthHandler Request UUID
authHandler env = mkAuthHandler $ \req -> do
  let cookies = maybe [] parseCookies (lookup "cookie" (requestHeaders req))
  case lookup "session_id" cookies of
    Nothing -> throwError err401
    Just sid -> getUserInfoFromSession (redisConn env) sid

serveApplication :: Env -> Application
serveApplication env =
  let context = authHandler env :. EmptyContext
   in serveWithContextT (Proxy :: Proxy APIRoutes) context (handleApp env) server
