module TODO.Prelude
  ( module RIO,
    module Data.UUID,
    module System.IO,
    module Data.Text,
    module Data.Foldable,
    generateUuidText,
  )
where

import Control.Exception.Safe
import Data.Foldable
import Data.Text (pack, unpack)
import Data.UUID (UUID, fromText, toByteString, toText)
import Data.UUID.V4
import RIO hiding (RIO (..))
import System.IO (print, putStr, putStrLn)

generateUuidText :: (MonadIO m) => m Text
generateUuidText = liftIO $ toText <$> nextRandom
