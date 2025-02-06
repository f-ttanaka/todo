module TODO.Handler.Todo where

import Servant
import TODO.App
import TODO.Prelude hiding (Handler)
import TODO.Query.Common (executeQuery)
import qualified TODO.Query.Todo as Query
import TODO.Type.Todo

getTodo :: UUID -> App [Todo]
getTodo = executeQuery Query.fetchAll

postTodo :: UUID -> Text -> App UUID
postTodo u t = executeQuery Query.insertOne (u, t)

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
