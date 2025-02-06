module TODO.Query.Common
  ( executeQuery,
  )
where

import Hasql.Pool
import qualified Hasql.Session as Session
import Hasql.Statement (Statement)
import TODO.Common.App
import TODO.Prelude

executeQuery :: Statement param res -> param -> App res
executeQuery query param = do
  pool <- getDbConnPool
  resM <- liftIO $ use pool (Session.statement param query)
  case resM of
    Right res -> return res
    Left e -> throwString $ show e
