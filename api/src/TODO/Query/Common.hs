module TODO.Query.Common
  ( createSession,
  )
where

import qualified Hasql.Connection as Conn
import Hasql.Session (Session)
import qualified Hasql.Session as Session
import TODO.Prelude

connectionSettings :: Conn.Settings
connectionSettings = Conn.settings "localhost" 5430 "root" "root" "todo-app"

pickRight :: (Show e) => IO (Either e a) -> IO a
pickRight m = do
  res <- m
  case res of
    Right a -> return a
    Left e -> fail (show e)

createSession :: Session a -> IO a
createSession ses = do
  connection <- pickRight $ Conn.acquire connectionSettings
  pickRight $ Session.run ses connection
