{-# LANGUAGE DataKinds #-}

module TODO.Application.Handler.User
  ( post,
    login,
  )
where

import Servant
import TODO.Application.Auth.Session
import TODO.Application.Handler.Internal
import TODO.Application.Internal
import qualified TODO.DB.Query.User as Query
import TODO.Data.User
import TODO.Lib.Crypt
import Web.Cookie

post :: UserResigter -> App NoContent
post (UserResigter n p) = do
  same <- executeQuery Query.fetchByName n
  case same of
    Just _ -> throwJsonError err500 "Already exists same name user!"
    Nothing -> do
      pHashed <- makeHashedText p
      let u' =
            UserOnSave
              { userName = n,
                userPassword = pHashed
              }
      void $ executeQuery Query.insert u'
      return NoContent

login :: UserResigter -> App (Headers '[Header "Set-Cookie" SetCookie] NoContent)
login (UserResigter n p) = do
  res <- executeQuery Query.fetchByName n
  sid <- generateUuid
  case res of
    Just (u, pHashed)
      | validatePasswordText pHashed p -> do
          sid' <- saveSession sid (userUuid u)
          return $ addHeader (setAuthCookie sid') NoContent
      | otherwise -> throwJsonError err401 "Invalid credentials"
    Nothing -> throwJsonError err400 "User not registered"
