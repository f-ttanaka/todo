module TODO.Handler.Admin.User
  ( index,
  )
where

import Lucid
import TODO.Admin.Index (renderUserList)
import TODO.Common.App
import TODO.Prelude
import TODO.Query.Common
import qualified TODO.Query.User as UQ

index :: App (Html ())
index = do
  users <- executeQuery UQ.fetchAll ()
  return $ renderUserList users
