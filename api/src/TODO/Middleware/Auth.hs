module TODO.Middleware.Auth (authMiddleware) where

import qualified Data.ByteString.Char8 as BS
import Data.List (lookup)
import Network.HTTP.Types.Status
import Network.Wai
import TODO.Prelude

authMiddleware :: Middleware
authMiddleware app req respond = do
  let cookies = fromMaybe "" $ lookup "Cookie" (requestHeaders req)
      token = lookup "auth_token" $ parseCookies cookies
  -- TODO: fix
  if token == Just "=valid_token"
    then app req respond
    else respond $ responseLBS status401 [("Content-Type", "text/plain")] "Unauthorized"

-- クッキーをパースする関数
parseCookies :: BS.ByteString -> [(BS.ByteString, BS.ByteString)]
parseCookies = map (BS.break (== '=')) . BS.split ';' . BS.filter (/= ' ')
