{-# LANGUAGE DeriveGeneric, OverloadedStrings, DuplicateRecordFields #-}

import Data.Aeson
import Data.Text
import qualified Data.ByteString.Lazy as B
import GHC.Generics


data Paragraph = Paragraph {
  text :: String,
  order :: Int
} deriving (Show, Generic)

instance FromJSON Paragraph

data Entity = Entity
  { etype :: String
  , text :: String
  , mentions :: [Mention]
  , disambiguation :: Disambiguation
  , count :: Int
  } deriving (Show,Generic)

data Mention = Mention
  { text :: String
  , location :: [Int]
  } deriving (Show, Generic)


data Disambiguation = Disambiguation
  { subtype :: [String]
  } deriving (Show, Generic)

instance FromJSON Disambiguation
instance FromJSON Mention

instance FromJSON Entity where
  parseJSON = genericParseJSON  $ defaultOptions {fieldLabelModifier = \x -> if x == "etype" then "type" else x}

data Cargos = Cargos
  { title :: String
  , start :: Int
  , end :: Int
  } deriving (Show, Generic)

instance FromJSON Cargos

data Document = Document
 { title :: String,
   natureza :: String,
   sexo :: String,
   cargos :: [String],
   cargos_p :: [Cargos],
   filename :: String,
   text :: String,
   paragraphs :: [Paragraph],
   entities :: [Entity]
}  deriving (Show, Generic)


instance FromJSON Document where
  parseJSON =
    genericParseJSON $ defaultOptions {fieldLabelModifier = \x -> if x == "cargos_p" then "cargos-p" else x}


input :: FilePath
input = "/Users/ar/work/cpdoc/dhbb-json/JSON/1.json"

main = do
  d <- (eitherDecode <$> B.readFile input) :: IO (Either String Document)
  return d
  
