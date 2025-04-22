module TODO.Prelude
  ( module Relude,
    module Data.UUID,
    module Data.Text,
    module Data.Foldable,
    module Control.Exception.Safe,
    generateUuid,
  )
where

import Control.Exception.Safe hiding (Handler)
import Data.Foldable (foldr')
import Data.Text (pack, unpack)
import Data.UUID (UUID, fromText, toByteString, toText)
import Data.UUID.V4
import Relude hiding (getAll, toText)

generateUuid :: (MonadIO m) => m UUID
generateUuid = liftIO $ nextRandom
