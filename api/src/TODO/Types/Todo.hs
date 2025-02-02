{-# LANGUAGE DeriveGeneric #-}

module TODO.Types.Todo (Todo (..), UUID) where

import Data.Aeson (FromJSON, ToJSON)
import Data.UUID (UUID)
import TODO.Prelude

data Todo = Todo
  { uuid :: UUID,
    title :: Text,
    completed :: Bool
  }
  deriving (Show, Generic)

instance ToJSON Todo

instance FromJSON Todo
