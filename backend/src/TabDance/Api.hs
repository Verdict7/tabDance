{-# LANGUAGE OverloadedStrings #-}

module TabDance.Api
  ( getTabs
  , deleteTabs
  , putTabs
  , postTabs )
where

import           TabDance.Model
import           TabDance.Api.Setup (App(..), runDb )

import           Servant
import           Servant.API (NoContent(..))
import           Control.Monad.Reader        (liftIO)
import           Database.Persist
import           Data.Time.LocalTime


getTabs :: App [Tab]
getTabs = do
  tabs <- runDb (selectList [] [])
  return $ map entityVal tabs

deleteTabs :: [Timestamp] -> App NoContent
deleteTabs ts = do
  runDb $ deleteWhere [TabTimestamp <-. ts]
  return NoContent

putTabs :: [Tab] -> App NoContent
putTabs cs = do
  runDb $ deleteWhere ( [TabPosition <-. map tabPosition cs]
                        ||. [TabTimestamp <-. map tabTimestamp cs])
  mapM (\tab -> runDb $ insertUnique tab) cs
  return NoContent

postTabs :: [Tab] -> App NoContent
postTabs cs = do
  mapM (\tab -> do
    mTab <- runDb (insertUnique tab)
    case mTab of
      Nothing -> throwError $ err409 { errBody = "Timestamps or positions not unique" }
      otherwise -> return NoContent)
    cs
  return NoContent
