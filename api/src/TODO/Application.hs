module TODO.Application (runApplication) where

import Network.Wai.Handler.Warp
import Network.Wai.Logger
import Servant.Auth.Server
import TODO.Application.Server
import TODO.Prelude

runApplication :: IO ()
runApplication = withStdoutLogger $ \aplogger -> do
  js <- defaultJWTSettings <$> generateKey
  let settings = setPort 3100 (setLogger aplogger defaultSettings)
  runSettings settings $ serveApplication js
