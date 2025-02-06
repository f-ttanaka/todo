{-# LANGUAGE DeriveGeneric #-}

module TODO.Type.Todo (Todo (..)) where

import Data.Aeson (FromJSON, ToJSON)
import TODO.Prelude

data Todo = Todo
  { uuid :: UUID,
    userUuid :: UUID,
    title :: Text,
    completed :: Bool
  }
  deriving (Show, Generic)

instance ToJSON Todo

instance FromJSON Todo
