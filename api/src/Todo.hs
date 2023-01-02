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
initDB conn =
  execute_ conn "CREATE TABLE IF NOT EXISTS todos \
                \ (id serial NOT NULL, title varchar(100) NOT NULL, completed boolean NOT NULL)"

data Todo = Todo
  { id :: Int
  , title :: String
  , completed :: Bool
  } deriving (Show, Generic)

instance ToJSON Todo
instance FromJSON Todo

instance FromRow Todo where
  fromRow = Todo <$> field <*> field <*> field

type API = "api" :> "todo" :> ReqBody '[JSON] Todo :> Post '[JSON] NoContent
  :<|> "api" :> "todo" :> Get '[JSON] [Todo]
  :<|> "api" :> "todo" :> Capture "id" Int :> Delete '[JSON] NoContent
  :<|> "api" :> "todo" :> "title" :> ReqBody '[JSON] Todo :> Put '[JSON] NoContent
  :<|> "api" :> "todo" :> "state" :> Capture "id" Int :> Put '[JSON] NoContent

api :: Proxy API
api = Proxy

server :: ConnectInfo -> Server API
server ci = postTodo :<|> getTodo :<|> deleteTodo :<|> updateTitle :<|> updateState
  where
    postTodo :: Todo -> Handler NoContent
    postTodo (Todo _ txt _) = do
      liftIO . withConnect ci $ \conn ->
        execute conn "INSERT INTO todos (title, completed) VALUES (?, false)" (Only txt)
      return NoContent

    getTodo :: Handler [Todo]
    getTodo = fmap (map (\(n,txt,c) -> Todo n txt c)) . liftIO $
     withConnect ci $ \conn ->
        query_ conn "SELECT id, title, completed FROM todos"

    deleteTodo :: Int -> Handler NoContent
    deleteTodo n = do
      liftIO . withConnect ci $ \conn ->
        execute conn "DELETE FROM todos WHERE id = ?" (Only n)
      return NoContent

    updateTitle :: Todo -> Handler NoContent
    updateTitle (Todo n txt _) = do
      liftIO . withConnect ci $ \conn ->
        execute conn "UPDATE todos SET title = ? WHERE id = ?" (txt,n)
      return NoContent
    
    updateState :: Int -> Handler NoContent
    updateState n = do
      liftIO . withConnect ci $ \conn ->
        execute conn "UPDATE todos SET completed = not(completed) WHERE id = ?" (Only n)
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