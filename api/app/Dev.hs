module Dev where

import Data.List (find)
import Hasql.Migration
import Hasql.Transaction.Sessions (IsolationLevel (..), Mode (..), transaction)
import Network.Wai.Handler.Warp
import Network.Wai.Logger
import TODO.Application (application)
import TODO.Prelude
import TODO.Queries.Common (createSession)

migrate :: IO ()
migrate = do
  ms <- loadMigrationsFromDirectory "./migrations"
  let msfromScratch = MigrationInitialization : ms
  results <- mapM (createSession . (transaction Serializable Write) . runMigration) msfromScratch
  case find isJust results of
    Just err -> print err
    _ -> putStrLn "All migrations are succeded."

startServer :: IO ()
startServer = withStdoutLogger $ \aplogger -> do
  let settings = setPort 3100 (setLogger aplogger defaultSettings)
  runSettings settings application
