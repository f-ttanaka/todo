{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module TODO.Application.Server.Admin
  ( adminServer
  , AdminRoutes
  )
where

import Lucid (Html)
import Servant.HTML.Lucid (HTML)
import qualified TODO.Application.Handler.Admin.User as H.U
import TODO.Application.Server.Internal
import TODO.Data.User (UserRegister)
import TODO.Pages.Admin.Index

{- FOURMOLU_DISABLE -}
type AdminRoutes =
  "admin" :> Get '[HTML] (Html ())
  :<|> "admin" :> "users" :> Get '[HTML] (Html ())
  :<|> "admin" :> "users" :> "new" :> Get '[HTML] (Html ())
  :<|> "admin" :> "users" :> "new" :> ReqBody '[FormUrlEncoded] UserRegister :> Verb 'POST 303 '[HTML] (Headers '[Header "Location" Text] NoContent)
{- FOURMOLU_ENABLE -}

adminServer :: ServerT AdminRoutes App
adminServer =
  return adminIndex
    :<|> H.U.index
    :<|> H.U.newUserForm
    :<|> H.U.handleCreateUser
