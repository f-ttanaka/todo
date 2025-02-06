{-# LANGUAGE FlexibleContexts #-}

module TODO.App
  ( App,
    Env,
    runApp,
    getDbConnPool,
    liftApp,
  )
where

import Hasql.Pool (Pool)
import TODO.Application.DB
import TODO.Prelude

data Env = Env
  { dbConnPool :: Pool
  }

type App = RIO Env

getDbConnPool :: App Pool
getDbConnPool = dbConnPool <$> ask

runApp :: App a -> IO a
runApp app = do
  pool <- makeDBConnPool
  let env =
        Env
          { dbConnPool = pool
          }
  runRIO env app

liftApp :: (MonadIO m, MonadReader Env m) => App a -> m a
liftApp = liftRIO
