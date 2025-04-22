module TODO.Application.Handler.Internal
  ( module Servant,
    throwJsonError,
    executeQuery,
  )
where

import Data.Aeson
import Hasql.Pool
import qualified Hasql.Session as Session
import Hasql.Statement (Statement)
import Servant
import TODO.Application.Internal

throwJsonError :: (MonadThrow m) => ServerError -> String -> m a
throwJsonError err msg =
  throwM
    err
      { errBody = encode $ object ["error" .= msg],
        errHeaders = [("Content-Type", "application/json")]
      }

executeQuery :: Statement param res -> param -> App res
executeQuery query param = do
  pool <- getDbConnPool
  resM <- liftIO $ use pool (Session.statement param query)
  case resM of
    Right res -> return res
    Left e -> throwString $ show e
