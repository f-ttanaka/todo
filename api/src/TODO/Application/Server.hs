{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module TODO.Application.Server (serveApplication) where

import qualified Data.Time as Time
import Network.Wai
import Servant
import Servant.Auth.Server
import TODO.Common.App
import TODO.Handler.Todo
import TODO.Handler.User
import TODO.Middleware.Cors
import TODO.Prelude hiding (Handler)
import TODO.Type.Todo
import TODO.Type.User

type APIPrefix = "api"

type TODOAPIRoutes =
  APIPrefix :> "todo" :> Auth '[Cookie] User :> Get '[JSON] [Todo]
    :<|> APIPrefix :> "todo" :> Auth '[Cookie] User :> ReqBody '[JSON] Text :> Post '[JSON] NoContent
    :<|> APIPrefix :> "todo" :> Auth '[Cookie] User :> Capture "uuid" UUID :> Delete '[JSON] Int
    :<|> APIPrefix :> "todo" :> Auth '[Cookie] User :> "title" :> Capture "uuid" UUID :> Capture "title" Text :> Put '[JSON] NoContent
    :<|> APIPrefix :> "todo" :> Auth '[Cookie] User :> "state" :> Capture "uuid" UUID :> Put '[JSON] NoContent

-- type TODOAPIRoutes = APIPrefix :> "todo" :> Auth '[Cookie] User :> TODOCRUDRoutes

serverForTODO :: ServerT TODOAPIRoutes App
serverForTODO =
  getTodo
    :<|> postTodo
    :<|> deleteTodo
    :<|> updateTitle
    :<|> updateStatus

type LoginAPIRoutes =
  APIPrefix :> "login" :> ReqBody '[JSON] UserResigter :> Post '[JSON] (Headers '[Header "Set-Cookie" SetCookie] NoContent)

type APIRoutes =
  TODOAPIRoutes
    :<|> LoginAPIRoutes

server :: JWTSettings -> CookieSettings -> ServerT APIRoutes App
server js cs =
  serverForTODO
    :<|> login js cs

api :: Proxy APIRoutes
api = Proxy

handleApp :: App a -> Handler a
handleApp action = do
  result <- liftIO $ try $ runApp action
  case result of
    Left e -> throwError e
    Right val -> return val

serveApplication :: JWTSettings -> Application
serveApplication js req res = do
  let cookieSettings =
        defaultCookieSettings
          { cookieIsSecure = NotSecure,
            cookieMaxAge = Just $ Time.secondsToDiffTime (60 * 60),
            cookieXsrfSetting = Nothing,
            sessionCookieName = "auth_token"
          }
      context = cookieSettings :. js :. EmptyContext
      server' = server js cookieSettings
      serve' = serveWithContext api context $ hoistServerWithContext api (Proxy :: Proxy '[CookieSettings, JWTSettings]) handleApp server'
  serve' req res
