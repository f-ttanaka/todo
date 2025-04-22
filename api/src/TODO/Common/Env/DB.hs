{-# LANGUAGE ScopedTypeVariables #-}

module TODO.Common.Env.DB
  ( makeDBConnPool,
    migrate,
  )
where

import Control.Exception.Safe (Handler (..))
import Control.Retry
import qualified Hasql.Connection.Setting as Conn
import qualified Hasql.Connection.Setting.Connection as Conn
import Hasql.Migration
import Hasql.Pool (Pool)
import qualified Hasql.Pool as Pool
import qualified Hasql.Pool.Config as Pool
import Hasql.Session (Session)
import Hasql.Transaction.Sessions
import System.IO.Error (IOError)
import TODO.Prelude

connectionSettings :: Conn.Connection
connectionSettings = Conn.string "postgresql://root:root@db:5432/todo_app"

poolSettings :: Pool.Config
poolSettings =
  Pool.settings
    [ Pool.size 10,
      Pool.staticConnectionSettings [Conn.connection connectionSettings]
    ]

-- リトライ付きプール取得関数
makeDBConnPool :: IO Pool
makeDBConnPool = recovering policy handlers $ \_ -> do
  putStrLn "Trying to acquire connection pool..."
  Pool.acquire poolSettings

-- リトライポリシー：1秒、2秒、4秒、8秒、16秒まで最大5回
policy :: RetryPolicy
policy = exponentialBackoff 1000000 <> limitRetries 5

handlers :: [RetryStatus -> Handler IO Bool]
handlers =
  [ const $ Handler $ \(_ :: Pool.UsageError) -> do
      putStrLn "Connection failed. Retrying..."
      pure True,
    const $ Handler $ \(_ :: IOError) -> do
      putStrLn "IOError while connecting. Retrying..."
      pure True
  ]

createSession :: Pool -> Session a -> IO a
createSession p ses = do
  conn <- Pool.use p ses
  case conn of
    Right a -> return a
    Left e -> throw e

migrate :: Pool -> IO ()
migrate p = do
  ms <- loadMigrationsFromDirectory "migrations"
  let msfromScratch = MigrationInitialization : ms
  results <- mapM (createSession p . transaction Serializable Write . runMigration) msfromScratch
  case find isJust results of
    Just (Just err) -> throwString $ show err
    _ -> putStrLn "All migrations are succeded."
