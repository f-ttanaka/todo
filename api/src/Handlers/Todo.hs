module Handlers.Todo where

import Data.Text (Text)
import Servant
import Control.Monad.IO.Class (liftIO)

import Types.Todo (Todo(..), UUID)
import qualified Queries.Todo as Query

getTodo :: Handler [Todo]
getTodo =  liftIO Query.fetchAll

postTodo :: Text -> Handler UUID
postTodo t = liftIO (Query.insertOne t)

deleteTodo :: UUID -> Handler Int
deleteTodo u = liftIO (Query.deleteById u)

updateTitle :: UUID -> Text -> Handler NoContent
updateTitle u t = liftIO (Query.updateTitle u t >> return NoContent)

updateStatus :: UUID -> Handler NoContent
updateStatus u = liftIO (Query.updateStatus u >> return NoContent)