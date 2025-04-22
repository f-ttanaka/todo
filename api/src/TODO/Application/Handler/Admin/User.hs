module TODO.Application.Handler.Admin.User
  ( index,
    newUserForm,
  )
where

import Lucid
import TODO.Application.Handler.Internal
import TODO.Application.Internal
import qualified TODO.DB.Query.User as UQ
import TODO.Pages.Admin.Users

index :: App (Html ())
index = do
  users <- executeQuery UQ.fetchAll ()
  return $ renderUserList users

newUserForm :: App (Html ())
newUserForm = return $ renderNewUserForm
