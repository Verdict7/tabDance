{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module TabDance.Api.Setup
    ( App(..)
    , Config(..) ) where


import           Control.Monad.Reader        (MonadIO, MonadReader, ReaderT)
import           Control.Monad.Except        (ExceptT, MonadError)
import           Database.Persist.Postgresql (ConnectionPool)
import           Network.Wai.Handler.Warp    (Port)
import           Servant                     (ServantErr)

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
