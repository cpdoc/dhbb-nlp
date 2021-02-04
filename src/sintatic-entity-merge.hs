{-# LANGUAGE OverloadedStrings #-}
import Data.Aeson
import Data.Text
import qualified Data.ByteString.Lazy as B

data Person =
  Person { firstName  :: !Text
         , lastName   :: !Text
         , age        :: Int
         , likesPizza :: Bool
           } deriving Show

instance FromJSON Person where
 parseJSON (Object v) =
    Person <$> v .: "firstName"
           <*> v .: "lastName"
           <*> v .: "age"
           <*> v .: "likesPizza"
--  parseJSON _ = mzero

instance ToJSON Person where
 toJSON (Person firstName lastName age likesPizza) =
    object [ "firstName"  .= firstName
           , "lastName"   .= lastName
           , "age"        .= age
           , "likesPizza" .= likesPizza
             ]


jsonFile :: FilePath
jsonFile = "trash.json"

getJSON :: IO B.ByteString
getJSON = B.readFile jsonFile


main = do
  content <- getJSON
  print $ decode content