{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings #-}

{-# LANGUAGE FlexibleInstances          #-}

module TabDance
    ( main ) where


import TabDance.Config
import TabDance.Common
import TabDance.Model
import TabDance.Api
import TabDance.Api.Setup


--import qualified Data.UUID                as UUID
--import qualified Data.UUID.V4             as UUID
import           Data.Int
import           Servant
import           Servant.API
import           Network.Wai
import           Network.Wai.Handler.Warp (run,Port)
--import           Import
import qualified Data.Text as Text
import qualified Data.ConfigFile as CF
import           Control.Monad.Logger    --(runStderrLoggingT)
import           Control.Monad.Reader        (MonadIO, MonadReader,
                                              ReaderT, runReaderT, asks, liftIO)
import           Control.Monad.Except        (ExceptT, MonadError)
import           Database.Persist
import           Database.Persist.Postgresql (runSqlPool,createPostgresqlPool,
                                              runMigration,ConnectionPool,toSqlKey,
                                              SqlPersistT)
import           Database.Persist.TH
import qualified Data.ByteString.Char8 as BS
import           System.IO (stdout, stderr)
import           System.Environment




type UsersAPI =
  "v1" :> "tabs" :> Get '[JSON] [Tab]
  :<|>
  "v1" :> "tabs" :> ReqBody '[JSON] [Timestamp] :> Delete '[JSON] NoContent
  :<|>
  "v1" :> "tabs" :> ReqBody '[JSON] [Tab] :> Put '[JSON] NoContent
  :<|>
  "v1" :> "tabs" :> ReqBody '[JSON] [Tab] :> Post '[JSON] NoContent


userServer :: ServerT UsersAPI App
userServer =
  getTabs
  :<|> deleteTabs
  :<|> putTabs
  :<|> postTabs

usersAPI :: Proxy UsersAPI
usersAPI = Proxy

appToServer :: Config -> Server UsersAPI
appToServer c = enter (convertApp c) userServer


convertApp :: Config -> App :~> ExceptT ServantErr IO
convertApp cfg = Nat (flip runReaderT cfg . runApp)

app :: Config -> Application
app c = serve usersAPI $ appToServer c



dbConfig :: CF.ConfigParser -> DBConfig
dbConfig configFile = DBConfig
                      (readConfig "localhost" configFile "db" "host")
                      (readConfig "tabDance" configFile "db" "database")
                      (readConfig "tabDance-user" configFile "db" "user")
                      (readConfig "123456" configFile "db" "password")
                      (readConfig "5432" configFile "db" "port" )


getAllConfigs e = do
  configFile <- readConfigFile "./tabDance.conf"
  pool <- makePool e (genConString $ dbConfig configFile) (defaultPoolSize configFile)
  let logger = setLogger e
      config = Config pool (getPortFromConfig configFile)
{-      uconfig = UserConfig
                (CreateUserConfig
                 (readConfig 3 configFile "naming" "unameLength")
                 (readConfig 5 configFile "naming" "passwordLength")
                )
                config -}
  return (pool, logger, config)


startServer :: Environment -> IO ()
startServer e = do
  (pool, logger, config) <- getAllConfigs e
  runSqlPool (runMigration usersMigration) pool
  let port = confPort config
  runStdoutLoggingT $ do logInfoN $ Text.pack $ "Listening on port " ++ show port
  run port $ logger $ app config

main :: IO ()
main = do
  args <- getArgs
  let environment = if (elem "deploy" args) then Production else Development
  startServer environment
