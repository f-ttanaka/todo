{-# LANGUAGE DataKinds #-}

module TODO.Handler.User where

import Servant
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

login :: UserResigter -> App (Headers '[Header "Set-Cookie" SetCookie] UUID)
login (UserResigter n p) = do
  res <- executeQuery Query.fetchByName n
  case res of
    Just (u, pHashed)
      | validatePasswordText pHashed p ->
          return $ addHeader (setAuthCookie "valid_token") (userUuid u)
      | otherwise -> throwM err401 {errBody = "Invalid credentials"}
    Nothing -> throwM err400 {errBody = "User not registered"}
  where
    setAuthCookie :: Text -> SetCookie
    setAuthCookie token =
      defaultSetCookie
        { setCookieName = "auth_token",
          setCookieValue = encodeUtf8 token,
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
