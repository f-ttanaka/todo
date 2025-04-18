module TODO.Application (runApplication) where

import Network.Wai.Handler.Warp
import Network.Wai.Logger
import TODO.Application.Server
import TODO.Common.App
import TODO.Prelude

runApplication :: IO ()
runApplication = do
  env <- initialEnv
  withStdoutLogger $ \aplogger -> do
    let settings = setPort 3100 (setLogger aplogger defaultSettings)
    runSettings settings (serveApplication env)
