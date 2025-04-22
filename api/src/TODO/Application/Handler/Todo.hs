module TODO.Application.Handler.Todo
  ( getTodo,
    postTodo,
    deleteTodo,
    updateStatus,
    updateTitle,
  )
where

import Servant
import TODO.Application.Handler.Internal
import TODO.Application.Internal
import qualified TODO.DB.Query.Todo as Query
import TODO.Data.Todo (Todo)

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
