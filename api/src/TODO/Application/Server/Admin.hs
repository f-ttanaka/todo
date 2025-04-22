{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module TODO.Application.Server.Admin
  ( adminServer,
    AdminRoutes,
  )
where

import Lucid (Html)
import Servant.HTML.Lucid (HTML)
import qualified TODO.Application.Handler.Admin.User as H.U
import TODO.Application.Server.Internal
import TODO.Pages.Admin.Index

type AdminRoutes =
  "admin"
    :> Get '[HTML] (Html ())
    :<|> "admin"
    :> "users"
    :> Get '[HTML] (Html ())
    :<|> "admin"
    :> "users"
    :> "new"
    :> Get '[HTML] (Html ())

adminServer :: ServerT AdminRoutes App
adminServer =
  return adminIndex
    :<|> H.U.index
    :<|> H.U.newUserForm
