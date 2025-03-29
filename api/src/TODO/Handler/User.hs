{-# LANGUAGE DataKinds #-}

module TODO.Handler.User where

import qualified Data.ByteString.Lazy as BSL
import qualified Data.Time as Time
import Servant
import Servant.Auth.Server
import TODO.Common.App
import TODO.Handler.Internal
import TODO.Lib.Crypt
import TODO.Prelude hiding (Handler)
import TODO.Query.Common (executeQuery)
import qualified TODO.Query.User as Query
import TODO.Type.User
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

login :: JWTSettings -> UserResigter -> App (Headers '[Header "Set-Cookie" SetCookie] NoContent)
login js (UserResigter n p) = do
  res <- executeQuery Query.fetchByName n
  now <- liftIO Time.getCurrentTime
  let expiry = Time.addUTCTime (60 * 60) now
  case res of
    Just (u, pHashed)
      | validatePasswordText pHashed p -> do
          mToken <- liftIO $ makeJWT u js (Just expiry)
          case mToken of
            Right token ->
              return $ addHeader (setAuthCookie token) NoContent
            Left err -> do
              liftIO $ print err
              throwJsonError err500 "JWT creation failed"
      | otherwise -> throwJsonError err401 "Invalid credentials"
    Nothing -> throwJsonError err400 "User not registered"
  where
    setAuthCookie :: BSL.ByteString -> SetCookie
    setAuthCookie token =
      defaultSetCookie
        { setCookieName = "auth_token",
          setCookieValue = BSL.toStrict token,
          setCookiePath = Just "/",
          setCookieHttpOnly = True,
          setCookieSecure = False, -- HTTPS 環境なら True に
          setCookieMaxAge = Just 3600, -- 1時間有効
          setCookieSameSite = Just sameSiteLax
        }
