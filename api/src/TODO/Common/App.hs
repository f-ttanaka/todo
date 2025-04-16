{-# LANGUAGE GeneralisedNewtypeDeriving #-}

module TODO.Common.App
  ( App,
    Env,
    redisConn,
    runApp,
    getDbConnPool,
    getRedisConn,
    initialEnv,
  )
where

import Database.Redis (Connection, connect, connectHost, defaultConnectInfo)
import Hasql.Pool (Pool)
import TODO.Common.Env.DB
import TODO.Prelude

data Env = Env
  { dbConnPool :: Pool,
    redisConn :: Connection
  }

newtype App a = App (ReaderT Env IO a)
  deriving
    ( Functor,
      Applicative,
      Monad,
      MonadIO,
      MonadThrow,
      MonadReader Env
    )

getDbConnPool :: App Pool
getDbConnPool = dbConnPool <$> ask

getRedisConn :: App Connection
getRedisConn = redisConn <$> ask

initialEnv :: IO Env
initialEnv = do
  migrate
  pool <- makeDBConnPool
  rc <- connect $ defaultConnectInfo {connectHost = "redis"}
  return $
    Env
      { dbConnPool = pool,
        redisConn = rc
      }

runApp :: Env -> App a -> IO a
runApp env (App m) = runReaderT m env
