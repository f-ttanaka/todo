{-# LANGUAGE DataKinds #-}

module TODO.Handler.User where

import TODO.App
import TODO.Lib.Crypt
import TODO.Prelude hiding (Handler)
import TODO.Query.Common (executeQuery)
import qualified TODO.Query.User as Query
import TODO.Type.User

post :: UserResigter -> App UUID
post (UserResigter n p) = do
  pHashed <- makeHashedText p
  let u' =
        UserOnSave
          { userName = n,
            userPassword = pHashed
          }
  executeQuery Query.insert u'

-- login :: JWTSettings -> UserResigter -> Handler (Headers '[Header "Set-Cookie" SetCookie] NoContent)
-- login js (UserResigter n p) = do
--   res <- liftIO $ Query.fetchByName n
--   case res of
--     Just (u, pHashed) | validatePasswordText pHashed p -> do
--       mApplyCookie <- liftIO $ acceptLogin defaultCookieSettings js u
--       case mApplyCookie of
--         Nothing -> throwError err401
--         Just applyCookies -> return $ applyCookies NoContent
