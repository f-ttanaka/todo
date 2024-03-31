{-# LANGUAGE DeriveGeneric #-}
module Types.Todo (Todo(..), UUID) where
import GHC.Generics (Generic)
import Data.Text (Text)
import Data.Aeson(ToJSON,FromJSON)
import Data.UUID (UUID)

data Todo = Todo
  { id :: UUID
  , title :: Text
  , completed :: Bool
  } deriving (Show, Generic)


instance ToJSON Todo
instance FromJSON Todo
