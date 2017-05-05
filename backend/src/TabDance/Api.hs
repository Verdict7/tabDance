module TabDance.Api
  ( getTabs
  , deleteTabs
  , putTabs
  , postTabs )
where

import           TabDance.Model
import           TabDance.Api.Setup (App(..))

import           Servant.API (NoContent(..))
import           Control.Monad.Reader        (liftIO)

getTabs :: App [Tab]
getTabs =
  return []

deleteTabs :: [Timestamp] -> App NoContent
deleteTabs ts = do
  liftIO $ putStrLn $ show ts
  return NoContent

putTabs :: [Tab] -> App NoContent
putTabs cs =
  return NoContent

postTabs :: [Tab] -> App NoContent
postTabs cs =
  return NoContent

