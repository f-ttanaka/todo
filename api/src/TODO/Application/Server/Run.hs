{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module TODO.Application.Server.Run (runApplication) where

import Network.Wai.Handler.Warp
import Network.Wai.Logger
import TODO.Application.Server.Admin
import TODO.Application.Server.Internal
import TODO.Application.Server.Protected
import TODO.Application.Server.Unprotected

type APIRoutes =
  AdminRoutes
    :<|> ProtectedRoutes
    :<|> UnprotectedRoutes

server :: ServerT APIRoutes App
server =
  adminServer
    :<|> protectedServer
    :<|> unprotectedServer

handleApp :: Env -> App a -> Handler a
handleApp env action = do
  result <- liftIO $ try $ runApp env action
  case result of
    Left e -> do
      -- ログ出力（必要なら env にロガーを組み込むとよい）
      liftIO $ putStrLn ("[ERROR] " ++ displayException e)
      throwError e
    Right val -> return val

serveApplication :: Env -> Application
serveApplication env =
  let context = authHandler env :. EmptyContext
   in serveWithContextT (Proxy :: Proxy APIRoutes) context (handleApp env) server

runApplication :: IO ()
runApplication = do
  env <- initialEnv
  withStdoutLogger $ \aplogger -> do
    let settings = setPort 3100 (setLogger aplogger defaultSettings)
    runSettings settings (serveApplication env)
