{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Todo where

import Data.Int (Int64)
import GHC.IO (bracket)
import Servant
import Data.Aeson(ToJSON,FromJSON)
import GHC.Generics(Generic)
import Network.Wai
import Network.Wai.Logger
import Network.Wai.Handler.Warp
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Control.Monad.IO.Class

connectInfo :: ConnectInfo
connectInfo = ConnectInfo
    { connectHost = "localhost"
    , connectPort = 5430
    , connectDatabase = "todo"
    , connectUser = "root"
    , connectPassword = "root"
    }

initDB :: Connection -> IO Int64
initDB conn = execute_ conn "CREATE TABLE IF NOT EXISTS todos (id integer, comment varchar(100))"

data Todo = Todo
  { id :: Integer
  , comment :: String
  } deriving (Show, Generic)

instance ToJSON Todo
instance FromJSON Todo

instance FromRow Todo where
  fromRow = Todo <$> field <*> field

type API = "todo" :> ReqBody '[JSON] Todo :> Post '[JSON] NoContent
  :<|> "todo" :> Get '[JSON] [Todo]
  :<|> "todo" :> Capture "id" Integer :> Delete '[JSON] NoContent

api :: Proxy API
api = Proxy

server :: ConnectInfo -> Server API
server ci = postTodo :<|> getTodo :<|> deleteTodo
  where
    postTodo :: Todo -> Handler NoContent
    postTodo (Todo num com) = do
      liftIO . withConnect ci $ \conn ->
        execute conn "INSERT INTO todos VALUES (?,?)" (num,com)
      return NoContent

    getTodo :: Handler [Todo]
    getTodo = fmap (map (\(num,com) -> Todo num com)) . liftIO $
     withConnect ci $ \conn ->
        query_ conn "SELECT id,comment FROM todos"

    deleteTodo :: Integer -> Handler NoContent
    deleteTodo n = do
      liftIO . withConnect ci $ \conn ->
        execute conn "DELETE FROM todos WHERE id = ?" (Only n)
      return NoContent

withConnect :: ConnectInfo -> (Connection -> IO c) -> IO c
withConnect ci = bracket (connect ci) close

runServant :: IO ()
runServant = do
  conn <- connect connectInfo
  initDB conn
  withStdoutLogger $ \aplogger -> do
    let settings = setPort 3100 (setLogger aplogger defaultSettings)
    runSettings settings (serve api (server connectInfo))