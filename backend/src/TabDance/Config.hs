
module TabDance.Config where

import qualified Data.ConfigFile as CF
import           Network.Wai (Middleware)
import           Network.Wai.Handler.Warp (Port)
import           Network.Wai.Middleware.RequestLogger (logStdout, logStdoutDev)
import           Database.Persist.Postgresql          (ConnectionPool,
                                                       ConnectionString,
                                                       createPostgresqlPool)
import           Control.Monad.Logger    (runStdoutLoggingT, runNoLoggingT)
import qualified Data.ByteString.Char8 as BS

import TabDance.Common

data Environment
    = Development
    | Test
    | Production
  deriving (Eq, Show, Read)

-- | This returns a 'Middleware' based on the environment that we're in.
setLogger :: Environment -> Middleware
setLogger Test = id
setLogger Development = logStdoutDev
setLogger Production = logStdout

data DBConfig = DBConfig
  {
    getHost :: String
  , getDBName :: String
  , getUser :: String
  , getPassword :: String
  , getDBPort :: String
  }

makePool :: Environment -> (Environment -> ConnectionString)
  -> (Environment -> Int) -> IO ConnectionPool
makePool e connStr poolSize =
  case e of
    Test -> runNoLoggingT (createPostgresqlPool (connStr e) (poolSize e))
    otherwise -> runStdoutLoggingT (createPostgresqlPool (connStr e) (poolSize e))

defaultPoolSize :: CF.ConfigParser -> Environment -> Int
defaultPoolSize cf Production = readConfig 8 cf "db" "productionPoolsize"
defaultPoolSize _ _ = 1

genConString :: DBConfig -> Environment -> ConnectionString
genConString c d = BS.pack $ concat $ zipWith (++)
                   ["host=", (if (d == Test) then " dbname=test" else " dbname="),
                     " user=", " password=", " port="]
                   ([getHost, getDBName, getUser, getPassword, getDBPort] <*> [c])

getPortFromConfig :: CF.ConfigParser -> Port
getPortFromConfig configFile = readConfig 8081 configFile "server" "port"
