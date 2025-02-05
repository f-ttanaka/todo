module TODO.Lib.Crypt
  ( HashedText,
    hashedText,
    makeHashedText,
    validatePasswordText,
  )
where

import Crypto.BCrypt
import qualified Data.Text.Encoding as TE
import TODO.Prelude

newtype HashedText = MK
  { hashedText :: Text
  }

makeHashedText :: (MonadIO m) => Text -> m HashedText
makeHashedText txt = do
  res <- liftIO $ hashPasswordUsingPolicy slowerBcryptHashingPolicy (encodeUtf8 txt)
  case res of
    Just bsHashed
      | Right txtHashed <- decodeUtf8' bsHashed ->
          return $ MK txtHashed
    _ -> throwString "hash error"

validatePasswordText :: Text -> Text -> Bool
validatePasswordText hash pass =
  validatePassword (TE.encodeUtf8 hash) (TE.encodeUtf8 pass)
