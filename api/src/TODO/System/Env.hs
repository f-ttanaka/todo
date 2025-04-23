{-# LANGUAGE DeriveGeneric #-}

module TODO.System.Env where

import System.Envy
import TODO.Prelude

data EnvVars = EnvVars
  { dbHost :: String
  , dbName :: String
  , dbUser :: String
  , dbPort :: String
  , dbPassword :: String
  , redisHost :: String
  , sessionCookieName :: String
  }
  deriving (Generic)

instance FromEnv EnvVars where
  fromEnv _ =
    EnvVars
      <$> env "DB_HOST"
      <*> env "DB_NAME"
      <*> env "DB_USER"
      <*> env "DB_PORT"
      <*> env "DB_PASSWORD"
      <*> env "REDIS_HOST"
      <*> env "SESSION_COOKIE_NAME"

getEnv :: IO EnvVars
getEnv = do
  mEnv <- decodeEnv :: IO (Either String EnvVars)
  case mEnv of
    Right e -> return e
    Left err -> throwString err
