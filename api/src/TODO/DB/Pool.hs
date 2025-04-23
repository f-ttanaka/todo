{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ScopedTypeVariables #-}

module TODO.DB.Pool
  ( makeDBConnPool
  ) where

import Control.Exception.Safe (Handler (..))
import Control.Retry
import Data.String.Interpolate (i)
import qualified Hasql.Connection.Setting as Conn
import qualified Hasql.Connection.Setting.Connection as Conn
import Hasql.Pool (Pool)
import qualified Hasql.Pool as Pool
import qualified Hasql.Pool.Config as Pool
import System.IO.Error (IOError)
import TODO.Prelude
import TODO.System.Env

connectionSettings :: EnvVars -> Conn.Connection
connectionSettings e =
  Conn.string [i|postgresql://#{dbUser e}:#{dbPassword e}@#{dbHost e}:#{dbPort e}/#{dbName e}|]

poolSettings :: EnvVars -> Pool.Config
poolSettings e =
  Pool.settings
    [ Pool.size 10
    , Pool.staticConnectionSettings [Conn.connection $ connectionSettings e]
    ]

-- リトライ付きプール取得関数
makeDBConnPool :: EnvVars -> IO Pool
makeDBConnPool e = recovering policy handlers $ \_ -> do
  putStrLn "Trying to acquire connection pool..."
  Pool.acquire $ poolSettings e

-- リトライポリシー：1秒、2秒、4秒、8秒、16秒まで最大5回
policy :: RetryPolicy
policy = exponentialBackoff 1000000 <> limitRetries 5

handlers :: [RetryStatus -> Handler IO Bool]
handlers =
  [ const $ Handler $ \(_ :: Pool.UsageError) -> do
      putStrLn "Connection failed. Retrying..."
      pure True
  , const $ Handler $ \(_ :: IOError) -> do
      putStrLn "IOError while connecting. Retrying..."
      pure True
  ]
