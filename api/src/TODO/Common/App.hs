{-# LANGUAGE FlexibleContexts #-}

module TODO.Common.App
  ( App,
    runApp,
    getDbConnPool,
  )
where

import Hasql.Pool (Pool)
import RIO (RIO (..))
import TODO.Common.Env.DB
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
