{-# LANGUAGE DataKinds #-}

module TODO.Application.Handler.Admin.User
  ( index
  , newUserForm
  , handleCreateUser
  )
where

import Lucid
import TODO.Application.Handler.Internal
import TODO.Application.Internal
import qualified TODO.DB.Query.User as UQ
import TODO.Data.User
import TODO.Lib.Crypt
import TODO.Pages.Admin.Users

index :: App (Html ())
index = do
  users <- executeQuery UQ.fetchAll ()
  return $ renderUserList users

newUserForm :: App (Html ())
newUserForm = return $ renderNewUserForm

handleCreateUser :: UserRegister -> App (Headers '[Header "Location" Text] NoContent)
handleCreateUser (UserRegister n p) = do
  same <- executeQuery UQ.fetchByName n
  case same of
    Just _ -> throwJsonError err500 "Already exists same name user!"
    Nothing -> do
      pHashed <- makeHashedText p
      let u' =
            UserOnSave
              { userName = n
              , userPassword = pHashed
              }
      void $ executeQuery UQ.insert u'
      return (addHeader "/admin/users" NoContent :: Headers '[Header "Location" Text] NoContent)
