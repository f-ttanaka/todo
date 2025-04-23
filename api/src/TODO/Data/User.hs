{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module TODO.Data.User
  ( User (..)
  , UserOnSave (..)
  , UserRegister (..)
  )
where

import Data.Aeson (FromJSON, ToJSON)
import TODO.Lib.Crypt
import TODO.Prelude (Generic, Show, Text, UUID)
import Web.FormUrlEncoded (FromForm)

-- uuid, name
data User = User
  { userUuid :: UUID
  , userName :: Text
  }
  deriving (Show, Generic, FromJSON, ToJSON)

data UserRegister = UserRegister
  { userName :: Text
  , userPassword :: Text -- not hashed
  }
  deriving (Show, Generic, FromJSON, FromForm)

-- name, password (hashed)
data UserOnSave = UserOnSave
  { userName :: Text
  , userPassword :: HashedText
  }
