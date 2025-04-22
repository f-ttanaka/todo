module TODO.DB.Migration (migrate) where

import Hasql.Migration
import Hasql.Pool (Pool)
import qualified Hasql.Pool as Pool
import Hasql.Session (Session)
import Hasql.Transaction.Sessions
import TODO.Prelude

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
