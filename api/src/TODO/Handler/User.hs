{-# LANGUAGE DataKinds #-}

module TODO.Handler.User where

import qualified Data.ByteString.Lazy as BSL
import qualified Data.Time as Time
import Servant
import Servant.Auth.Server
import TODO.Common.App
import TODO.Lib.Crypt
import TODO.Prelude hiding (Handler)
import TODO.Query.Common (executeQuery)
import qualified TODO.Query.User as Query
import TODO.Type.User
import Web.Cookie

post :: UserResigter -> App UUID
post (UserResigter n p) = do
  pHashed <- makeHashedText p
  let u' =
        UserOnSave
          { userName = n,
            userPassword = pHashed
          }
  executeQuery Query.insert u'

login :: JWTSettings -> CookieSettings -> UserResigter -> App (Headers '[Header "Set-Cookie" SetCookie] NoContent)
login js cs (UserResigter n p) = do
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
              throwM err500 {errBody = "JWT creation failed"}
      | otherwise -> throwM err401 {errBody = "Invalid credentials"}
    Nothing -> throwM err400 {errBody = "User not registered"}
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

-- login :: JWTSettings -> UserResigter -> Handler (Headers '[Header "Set-Cookie" SetCookie] NoContent)
-- login js (UserResigter n p) = do
--   res <- liftIO $ Query.fetchByName n
--   case res of
--     Just (u, pHashed) | validatePasswordText pHashed p -> do
--       mApplyCookie <- liftIO $ acceptLogin defaultCookieSettings js u
--       case mApplyCookie of
--         Nothing -> throwError err401
--         Just applyCookies -> return $ applyCookies NoContent
