module TODO.Handler.Todo where

import qualified Data.ByteString.Lazy.Char8 as BS
import Servant
import Servant.Auth.Server
import TODO.Common.App
import TODO.Prelude hiding (Handler)
import TODO.Query.Common (executeQuery)
import qualified TODO.Query.Todo as Query
import TODO.Type.Todo (Todo)
import TODO.Type.User (User)
import qualified TODO.Type.User as U

getTodo :: AuthResult User -> App [Todo]
getTodo (Authenticated u) = executeQuery Query.fetchAll (U.userUuid u)
getTodo err = throwM err401 {errBody = BS.pack $ show err}

postTodo :: AuthResult User -> Text -> App NoContent
postTodo (Authenticated u) t = do
  void $ executeQuery Query.insertOne (U.userUuid u, t)
  return NoContent
postTodo _ _ = throwM err401

deleteTodo :: AuthResult User -> UUID -> App Int
deleteTodo (Authenticated usr) uid = executeQuery Query.deleteById (U.userUuid usr, uid)
deleteTodo _ _ = throwM err401

updateTitle :: AuthResult User -> UUID -> Text -> App NoContent
updateTitle (Authenticated usr) u t = do
  executeQuery Query.updateTitle (U.userUuid usr, u, t)
  return NoContent
updateTitle _ _ _ = throwM err401

updateStatus :: AuthResult User -> UUID -> App NoContent
updateStatus (Authenticated usr) u = do
  executeQuery Query.updateStatus (U.userUuid usr, u)
  return NoContent
