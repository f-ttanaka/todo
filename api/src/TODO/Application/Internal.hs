{-# LANGUAGE GeneralisedNewtypeDeriving #-}

module TODO.Application.Internal
  ( module TODO.Prelude
  , App
  , Env
  , redisConn
  , runApp
  , getDbConnPool
  , getRedisConn
  , initialEnv
  )
where

import Database.Redis (Connection, connect, connectHost, defaultConnectInfo)
import Hasql.Pool (Pool)
import TODO.DB.Migration
import TODO.DB.Pool
import TODO.Prelude
import TODO.System.Env

data Env = Env
  { dbConnPool :: Pool
  , redisConn :: Connection
  }

newtype App a = App (ReaderT Env IO a)
  deriving
    ( Functor
    , Applicative
    , Monad
    , MonadIO
    , MonadThrow
    , MonadReader Env
    )

getDbConnPool :: App Pool
getDbConnPool = dbConnPool <$> ask

getRedisConn :: App Connection
getRedisConn = redisConn <$> ask

initialEnv :: IO Env
initialEnv = do
  e <- getEnv
  pool <-
    makeDBConnPool e
  migrate pool
  rc <- connect $ defaultConnectInfo {connectHost = redisHost e}
  return $
    Env
      { dbConnPool = pool
      , redisConn = rc
      }

runApp :: Env -> App a -> IO a
runApp env (App m) = runReaderT m env
