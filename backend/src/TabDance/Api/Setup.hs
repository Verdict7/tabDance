{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE FlexibleContexts           #-}

module TabDance.Api.Setup
    ( App(..)
    , Config(..)
    , runDb ) where


import           Control.Monad.Reader        (MonadIO, MonadReader, ReaderT
                                             , asks, liftIO)
import           Control.Monad.Except        (ExceptT, MonadError)
import           Database.Persist.Postgresql (ConnectionPool)
import           Network.Wai.Handler.Warp    (Port)
import           Servant                     (ServantErr)
import           Database.Persist.Postgresql (runSqlPool, SqlPersistT)


data Config = Config
  {
    confPool :: ConnectionPool
  , confPort :: Port
  }


newtype App a
    = App
    { runApp :: ReaderT Config (ExceptT ServantErr IO) a
    } deriving ( Functor, Applicative, Monad, MonadReader Config,
                 MonadError ServantErr, MonadIO)
--runDb ::
runDb :: (MonadReader Config m, MonadIO m) => SqlPersistT IO b -> m b
runDb query = do
--    config <- asks getConfig
  pool <- asks confPool
  liftIO $ runSqlPool query $ pool
