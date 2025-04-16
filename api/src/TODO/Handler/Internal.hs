module TODO.Handler.Internal
  ( throwJsonError,
  )
where

import Data.Aeson
import Servant
import TODO.Prelude hiding (Handler)

throwJsonError :: (MonadThrow m) => ServerError -> String -> m a
throwJsonError err msg =
  throwM
    err
      { errBody = encode $ object ["error" .= msg],
        errHeaders = [("Content-Type", "application/json")]
      }
