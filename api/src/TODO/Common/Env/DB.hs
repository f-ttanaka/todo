module TODO.Common.Env.DB where

import qualified Hasql.Connection as Conn
import Hasql.Pool (Pool)
import qualified Hasql.Pool as Pool
import qualified Hasql.Pool.Config as Pool
import TODO.Prelude

makeDBConnPool :: (MonadIO m) => m Pool
makeDBConnPool = do
  let dbConn = Conn.settings "localhost" 5430 "root" "root" "todo-app"
      dbPoolSettings =
        Pool.settings
          [ Pool.size 10,
            Pool.staticConnectionSettings dbConn
          ]
  liftIO $ Pool.acquire dbPoolSettings
