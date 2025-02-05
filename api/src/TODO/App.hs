{-# LANGUAGE FlexibleContexts #-}

module TODO.App
  ( App,
    Env,
    runApp,
    getDbConnPool,
    liftApp,
  )
where

import qualified Hasql.Connection as Conn
import Hasql.Pool (Pool)
import qualified Hasql.Pool as Pool
import qualified Hasql.Pool.Config as Pool
import TODO.Prelude

data Env = Env
  { dbConnPool :: Pool
  }

type App = RIO Env

getDbConnPool :: App Pool
getDbConnPool = dbConnPool <$> ask

runApp :: App a -> IO a
runApp app = do
  let dbConn = Conn.settings "localhost" 5430 "root" "root" "todo-app"
      dbPoolSettings =
        Pool.settings
          [ Pool.size 10,
            Pool.staticConnectionSettings dbConn
          ]
  pool <- Pool.acquire dbPoolSettings
  let env =
        Env
          { dbConnPool = pool
          }
  runRIO env app

liftApp :: (MonadIO m, MonadReader Env m) => App a -> m a
liftApp = liftRIO
