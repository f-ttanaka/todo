module TODO.Handler.Todo where

import Servant
import TODO.Common.App
import TODO.Prelude hiding (Handler)
import TODO.Query.Common (executeQuery)
import qualified TODO.Query.Todo as Query
import TODO.Type.Todo (Todo)
import TODO.Type.User (User)
import qualified TODO.Type.User as U

getTodo :: UUID -> App [Todo]
getTodo u = executeQuery Query.fetchAll u

postTodo :: UUID -> Text -> App NoContent
postTodo u t = do
  void $ executeQuery Query.insertOne (u, t)
  return NoContent

deleteTodo :: UUID -> UUID -> App Int
deleteTodo u uid = executeQuery Query.deleteById (u, uid)

updateTitle :: UUID -> UUID -> Text -> App NoContent
updateTitle usr u t = do
  executeQuery Query.updateTitle (usr, u, t)
  return NoContent

updateStatus :: UUID -> UUID -> App NoContent
updateStatus usr u = do
  executeQuery Query.updateStatus (usr, u)
  return NoContent
