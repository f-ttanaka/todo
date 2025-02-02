module Main (main) where

import Network.Wai.Handler.Warp
import Network.Wai.Logger
import TODO.Application (application)
import TODO.Prelude

main :: IO ()
main = withStdoutLogger $ \aplogger -> do
  let settings = setPort 3100 (setLogger aplogger defaultSettings)
  runSettings settings application
