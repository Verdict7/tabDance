{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE DeriveGeneric #-}
--{-# LANGUAGE DeriveAnyClass #-}

module TabDance.Model where

import           Database.Persist
import           Database.Persist.Postgresql
import           Database.Persist.TH
import           Data.Aeson
import           GHC.Generics
import           Control.Monad
import           Data.Time.Clock

type Timestamp = UTCTime

share [ mkPersist sqlSettings
      , mkDeleteCascade sqlSettings
      , mkMigrate "usersMigration"]
  [persistLowerCase|
Tab
    url String
    position Int
    timestamp Timestamp
    UniquePosition position
    UniqueTimestamp timestamp
    deriving Show Eq Generic
|]

instance FromJSON Tab where
  parseJSON (Object v) = Tab
    <$> v .: "url"
    <*> v .: "position"
    <*> v .: "timestamp"

instance ToJSON Tab where
  toJSON (Tab u p t) = object ["url" .= u, "position" .= p, "timestamp" .= t]
