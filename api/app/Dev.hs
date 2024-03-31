module Dev where

import Hasql.Migration
import Hasql.Transaction.Sessions (transaction, Mode(..), IsolationLevel(..))
import Queries.Common (createSession)
import Data.List (find)
import Data.Maybe (isJust)
import Application (application)

import Network.Wai.Logger
import Network.Wai.Handler.Warp

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