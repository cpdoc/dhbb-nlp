import Control.Applicative
import Control.Monad
import Text.JSON

data Location = Int

data Disambiguation = Disambiguation
    { subtype :: [String]}

data Mention = Mention
    { txt :: String
    , locations :: [Location]}

data Entity = Entity
    { entType :: String
    , text :: String
    , mentions :: [Mention]
    , disambiguation :: Disambiguation
    , count :: Int}

-- instance JSON Mention where
--     showJSON = undefined 
--     readJSON (JSObject obj) =
--         Entity            <$>
--         obj ! "text"      <*>
--         obj ! "location"
--     readJSON _ = mzero 


instance JSON Entity where
    showJSON = undefined 
    readJSON (JSObject obj) =
        Entity                 <$>
        obj ! "type"           <*>
        obj ! "text"           <*>
        obj ! "mentions"       <*>
        obj ! "disambiguation" <*>
        obj ! "count"
    readJSON _ = mzero 
-- instance JSON Address where
--     -- Keep the compiler quiet
--     showJSON = undefined

--     readJSON (JSObject obj) =
--         Address        <$>
--         obj ! "house"  <*>
--         obj ! "street" <*>
--         obj ! "city"   <*>
--         obj ! "state"  <*>
--         obj ! "zip"
--     readJSON _ = mzero


-- instance JSON Person where
--     -- Keep the compiler quiet
--     showJSON = undefined

--     readJSON (JSObject obj) =
--         Person       <$>
--         obj ! "name" <*>
--         obj ! "age"  <*>
--         obj ! "address"
--     readJSON _ = mzero

-- data Address = Address
--     { house  :: Integer
--     , street :: String
--     , city   :: String
--     , state  :: String
--     -- Renamed so as not to conflict with zip from Prelude
--     , zipC   :: Integer
--     } deriving (Show)

-- data Person = Person
--     { name    :: String
--     , age     :: Integer
--     , address :: Address
--     } deriving (Show)

-- aa :: String
-- aa = "{\"name\": \"some body\", \"age\" : 23, \"address\" : {\"house\" : 285, \"street\" : \"7th Ave.\", \"city\" : \"New York\", \"state\" : \"New York\", \"zip\" : 10001}}"

(!) :: (JSON a) => JSObject JSValue -> String -> Result a
(!) = flip valFromObj




-- main = print (decode aa :: Result Person)