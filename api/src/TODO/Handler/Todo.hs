module TODO.Handler.Todo where

import Servant
import TODO.App
import TODO.Prelude hiding (Handler)
import TODO.Query.Common (executeQuery)
import qualified TODO.Query.Todo as Query
import TODO.Type.Todo

getTodo :: App [Todo]
getTodo = executeQuery Query.fetchAll ()

postTodo :: Text -> App UUID
postTodo = executeQuery Query.insertOne

deleteTodo :: UUID -> App Int
deleteTodo = executeQuery Query.deleteById

updateTitle :: UUID -> Text -> App NoContent
updateTitle u t = do
  executeQuery Query.updateTitle (u, t)
  return NoContent

updateStatus :: UUID -> App NoContent
updateStatus u = do
  executeQuery Query.updateStatus u
  return NoContent
