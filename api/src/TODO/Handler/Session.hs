{-# LANGUAGE FlexibleContexts #-}

module TODO.Handler.Session
  ( saveSession,
    getUserInfoFromSession,
    setAuthCookie,
  )
where

import Control.Monad.Error.Class (MonadError)
import qualified Data.ByteString.Lazy as BSL
import qualified Data.Text.Encoding as TE
import Database.Redis (Connection, get, runRedis, setex)
import Servant
import TODO.Common.App
import TODO.Prelude
import Web.Cookie

saveSession :: Text -> UUID -> App BSL.ByteString
saveSession sessionId uu = do
  conn <- getRedisConn
  liftIO . runRedis conn $ do
    let sid' = encodeUtf8 sessionId
    -- 3600秒（1時間）で自動期限切れ
    void $ setex ("session:" <> sid') 3600 (TE.encodeUtf8 $ toText uu)
    return $ BSL.fromStrict sid'

getUserInfoFromSession :: (MonadIO m, MonadError ServerError m) => Connection -> ByteString -> m UUID
getUserInfoFromSession rc sid = do
  result <- liftIO $ runRedis rc $ get ("session:" <> sid)
  case result of
    Right (Just userJson) -> do
      case fromText $ TE.decodeUtf8 userJson of
        Just u -> return u
        _ -> throwError err403
    _ -> throwError err403

setAuthCookie :: BSL.ByteString -> SetCookie
setAuthCookie sessionId =
  defaultSetCookie
    { setCookieName = "session_id",
      setCookieValue = BSL.toStrict sessionId,
      setCookiePath = Just "/",
      setCookieHttpOnly = True,
      setCookieMaxAge = Just 3600, -- 1時間有効
      setCookieSameSite = Just sameSiteLax,
      setCookieSecure = False -- HTTPSを使用している場合はTrue
    }
