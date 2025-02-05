{-# LANGUAGE DeriveGeneric #-}

module TODO.Type.User
  ( User (..),
    UserOnSave (..),
    UserResigter (..),
  )
where

import Data.Aeson (FromJSON, ToJSON)
import Servant.Auth.Server (ToJWT)
import TODO.Lib.Crypt
import TODO.Prelude

-- uuid, name
data User = User
  { userUuid :: UUID,
    userName :: Text
  }
  deriving (Show, Generic)

data UserResigter = UserResigter
  { userName :: Text,
    userPassword :: Text -- not hashed
  }

-- name, password (hashed)
data UserOnSave = UserOnSave
  { userName :: Text,
    userPassword :: HashedText
  }

instance ToJSON User

instance ToJWT User

instance FromJSON User
