{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module TODO.Application.Server.Unprotected
  ( UnprotectedRoutes,
    unprotectedServer,
  )
where

import Servant
import TODO.Application.Handler.User
import TODO.Application.Internal
import TODO.Data.User
import Web.Cookie

type UnprotectedRoutes =
  "api" :> "login" :> ReqBody '[JSON] UserResigter :> Post '[JSON] (Headers '[Header "Set-Cookie" SetCookie] NoContent)
    :<|> "api" :> "user" :> ReqBody '[JSON] UserResigter :> Post '[JSON] NoContent

unprotectedServer :: ServerT UnprotectedRoutes App
unprotectedServer =
  login
    :<|> post
