module TODO.Handler.Todo where

import Servant
import TODO.Prelude hiding (Handler)
import qualified TODO.Query.Todo as Query
import TODO.Type.Todo (Todo (..), UUID)

getTodo :: Handler [Todo]
getTodo = liftIO Query.fetchAll

postTodo :: Text -> Handler UUID
postTodo t = liftIO (Query.insertOne t)

deleteTodo :: UUID -> Handler Int
deleteTodo u = liftIO (Query.deleteById u)

updateTitle :: UUID -> Text -> Handler NoContent
updateTitle u t = liftIO (Query.updateTitle u t >> return NoContent)

updateStatus :: UUID -> Handler NoContent
updateStatus u = liftIO (Query.updateStatus u >> return NoContent)
