module TODO.Common.Env.DB
  ( makeDBConnPool,
    migrate,
  )
where

import qualified Hasql.Connection as Conn hiding (Connection)
import qualified Hasql.Connection.Setting as Conn
import qualified Hasql.Connection.Setting.Connection as Conn
import Hasql.Migration
import Hasql.Pool (Pool)
import qualified Hasql.Pool as Pool
import qualified Hasql.Pool.Config as Pool
import Hasql.Session (Session)
import qualified Hasql.Session as Session
import Hasql.Transaction.Sessions (IsolationLevel (..), Mode (..), transaction)
import TODO.Prelude

connectionSettings :: Conn.Connection
connectionSettings = Conn.string "postgresql://root:root@db:5432/todo_app"

makeDBConnPool :: (MonadIO m) => m Pool
makeDBConnPool = do
  let dbPoolSettings =
        Pool.settings
          [ Pool.size 10,
            Pool.staticConnectionSettings [Conn.connection connectionSettings]
          ]
  liftIO $ Pool.acquire dbPoolSettings

pickRight :: (Show e) => IO (Either e a) -> IO a
pickRight m = do
  res <- m
  case res of
    Right a -> return a
    Left e -> fail (show e)

createSession :: Session a -> IO a
createSession ses = do
  connection <- pickRight $ Conn.acquire [Conn.connection connectionSettings]
  pickRight $ Session.run ses connection

migrate :: IO ()
migrate = do
  ms <- loadMigrationsFromDirectory "migrations"
  let msfromScratch = MigrationInitialization : ms
  results <- mapM (createSession . transaction Serializable Write . runMigration) msfromScratch
  case find isJust results of
    Just (Just err) -> throwString $ show err
    _ -> putStrLn "All migrations are succeded."
