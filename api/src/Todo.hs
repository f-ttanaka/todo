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
import Network.Wai.Middleware.Cors
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
  { id :: Int
  , comment :: String
  } deriving (Show, Generic)

instance ToJSON Todo
instance FromJSON Todo

instance FromRow Todo where
  fromRow = Todo <$> field <*> field

type API = "api" :> "todo" :> ReqBody '[JSON] Todo :> Post '[JSON] NoContent
  :<|> "api" :> "todo" :> Get '[JSON] [Todo]
  :<|> "api" :> "todo" :> Capture "id" Int :> Delete '[JSON] NoContent
  :<|> "api" :> "todo" :> "comment" :> ReqBody '[JSON] Todo :> Put '[JSON] NoContent
  :<|> "api" :> "todo" :> "ids" :> Put '[JSON] NoContent

api :: Proxy API
api = Proxy

server :: ConnectInfo -> Server API
server ci = postTodo :<|> getTodo :<|> deleteTodo :<|> putCommentTodo :<|> putIdsTodo
  where
    postTodo :: Todo -> Handler NoContent
    postTodo (Todo n txt) = do
      liftIO . withConnect ci $ \conn ->
        execute conn "INSERT INTO todos VALUES (?,?)" (n, txt)
      return NoContent

    getTodo :: Handler [Todo]
    getTodo = fmap (map (\(n,txt) -> Todo n txt)) . liftIO $
     withConnect ci $ \conn ->
        query_ conn "SELECT id,comment FROM todos"

    deleteTodo :: Int -> Handler NoContent
    deleteTodo n = do
      liftIO . withConnect ci $ \conn ->
        execute conn "DELETE FROM todos WHERE id = ?" (Only n)
      return NoContent

    putCommentTodo :: Todo -> Handler NoContent
    putCommentTodo (Todo n txt) = do
      liftIO . withConnect ci $ \conn ->
        execute conn "UPDATE todos SET comment = ? \
                      \ FROM \
                      \    WHERE id = ?" (txt,n)
      return NoContent
    
    putIdsTodo :: Handler NoContent
    putIdsTodo = do
      liftIO . withConnect ci $ \conn ->
        execute_ conn "UPDATE todos SET id = tmp.new_id \
                      \  FROM \
                      \    (SELECT row_number() over() as new_id, id, comment FROM todos) as tmp \
                      \  WHERE \
                      \    todos.id = tmp.id"
      return NoContent

withConnect :: ConnectInfo -> (Connection -> IO c) -> IO c
withConnect ci = bracket (connect ci) close

todoCors :: Middleware
todoCors = cors (const $ Just policy)
  where
    policy = simpleCorsResourcePolicy
      { corsRequestHeaders = ["Content-Type"]
      , corsMethods = ["GET", "POST", "DELETE", "PUT"] }

runServant :: IO ()
runServant = do
  conn <- connect connectInfo
  initDB conn
  withStdoutLogger $ \aplogger -> do
    let settings = setPort 3100 (setLogger aplogger defaultSettings)
    runSettings settings (todoCors (serve api (server connectInfo)))