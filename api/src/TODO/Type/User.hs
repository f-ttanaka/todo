{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module TODO.Type.User
  ( User (..),
    UserOnSave (..),
    UserResigter (..),
  )
where

import Data.Aeson (FromJSON, ToJSON)
import TODO.Lib.Crypt
import TODO.Prelude

-- uuid, name
data User = User
  { userUuid :: UUID,
    userName :: Text
  }
  deriving (Show, Generic, FromJSON, ToJSON)

data UserResigter = UserResigter
  { userName :: Text,
    userPassword :: Text -- not hashed
  }
  deriving (Show, Generic, FromJSON)

-- name, password (hashed)
data UserOnSave = UserOnSave
  { userName :: Text,
    userPassword :: HashedText
  }
