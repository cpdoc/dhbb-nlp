{-# LANGUAGE OverloadedStrings #-}
import Data.Aeson
import Data.Text
import qualified Data.ByteString.Lazy as B

data Mention = Mention
  { text :: String
  , location :: [Int]
  } deriving Show

newtype Disambiguation = Disambiguation
  { subtypes :: [String]
  } deriving Show

data Entity = Entity
  { entType :: String
  , entText :: String
  , mentions :: [Mention]
  , disambiguation :: Disambiguation
  , count :: Int
  } deriving Show

-- data Person =
--   Person { firstName  :: !Text
--          , lastName   :: !Text
--          , age        :: Int
--          , likesPizza :: Bool
--            } deriving Show

-- instance FromJSON Person where
--  parseJSON (Object v) =
--     Person <$> v .: "firstName"
--            <*> v .: "lastName"
--            <*> v .: "age"
--            <*> v .: "likesPizza"
--  parseJSON _ = mzero

instance FromJSON Entity where
  parseJSON (Object v) =
    Entity <$> v .: "type"
           <*> v .: "text"
           <*> v .: "mentions"
           <*> v .: "disambiguation"
           <*> v .: "count"

-- instance ToJSON Person where
--  toJSON (Person firstName lastName age likesPizza) =
--     object [ "firstName"  .= firstName
--            , "lastName"   .= lastName
--            , "age"        .= age
--            , "likesPizza" .= likesPizza
--              ]

instance ToJSON Entity where
  toJSON (Entity entType entText mentions disambiguation count) =
    object [ "type"           .= entType
           , "text"           .= entText
           , "mentions"       .= mentions
           , "disambiguation" .= disambiguation
           , "count"          .= count
           ]


-- jsonFile :: FilePath
-- jsonFile = "trash.json"

-- getJSON :: IO B.ByteString
-- getJSON = B.readFile jsonFile


-- main = do
--   content <- getJSON
--   print $ decode content