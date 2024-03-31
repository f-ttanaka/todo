module Main (main) where

import Application (application)

import Network.Wai.Logger
import Network.Wai.Handler.Warp

main :: IO ()
main = withStdoutLogger $ \aplogger -> do
  let settings = setPort 3100 (setLogger aplogger defaultSettings)
  runSettings settings application
