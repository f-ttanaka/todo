module Dev where

import Data.List (find)
import qualified Hasql.Connection as Conn
import Hasql.Migration
import Hasql.Session (Session)
import qualified Hasql.Session as Session
import Hasql.Transaction.Sessions (IsolationLevel (..), Mode (..), transaction)
import System.IO
import TODO.Application (runApplication)
import TODO.Lib.Crypt
import TODO.Prelude
import qualified TODO.Query.User as U
import TODO.Type.User

-- TODO: improve and use connection pool in migration
connectionSettings :: Conn.Settings
connectionSettings = Conn.settings "localhost" 5430 "root" "root" "todo-app"

pickRight :: (Show e) => IO (Either e a) -> IO a
pickRight m = do
  res <- m
  case res of
    Right a -> return a
    Left e -> fail (show e)

createSession :: Session a -> IO a
createSession ses = do
  connection <- pickRight $ Conn.acquire connectionSettings
  pickRight $ Session.run ses connection

migrate :: IO ()
migrate = do
  ms <- loadMigrationsFromDirectory "./migrations"
  let msfromScratch = MigrationInitialization : ms
  results <- mapM (createSession . transaction Serializable Write . runMigration) msfromScratch
  case find isJust results of
    Just err -> print err
    _ -> putStrLn "All migrations are succeded."

createTestUser :: IO ()
createTestUser = do
  pass <- makeHashedText "password"
  let u = UserOnSave "test_user" pass
  void $ createSession $ Session.statement u U.insert

startServer :: IO ()
startServer = runApplication
