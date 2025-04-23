module TODO.Lib.Env
  ( getEnvSafe
  ) where

import TODO.Prelude

getEnvSafe :: (MonadIO m, MonadThrow m) => String -> m String
getEnvSafe key = do
  mVar <- lookupEnv key
  case mVar of
    Just v -> return v
    _ -> throwString $ "no env var: " <> key
