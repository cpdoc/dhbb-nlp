
-- | This JSON package retains the order of array elements.
--   JSON: http://www.ietf.org/rfc/rfc4627.txt

module JSON (
    JSON(..)
  , parseJSON
  ) where

import Control.Applicative ((<*),(*>),(<$>),(<$))
import Control.Monad (void)
import Data.Char
import Data.List (foldl')
import Text.Parsec
import Text.Parsec.String

----------------------------------------------------------------

parseJSON :: String -> Either ParseError JSON
parseJSON xs = parse json "json" xs

----------------------------------------------------------------

data JSON = JSNull
          | JSBool Bool
          | JSNumber Int
          | JSString String
          | JSArray [JSON]
          | JSObject [(String,JSON)]
          deriving (Show, Eq)

----------------------------------------------------------------

json :: Parser JSON
json = ws *> jsValue

jsValue :: Parser JSON
jsValue = choice [jsNull,jsBool,jsObject,jsArray,jsNumber,jsString]

----------------------------------------------------------------

-- |
--
-- >>> parseJSON "  null "
-- Right JSNull
jsNull :: Parser JSON
jsNull = jsAtom "null" JSNull

-- |
--
-- >>> parseJSON "  false "
-- Right (JSBool False)
-- >>> parseJSON "true"
-- Right (JSBool True)
jsBool :: Parser JSON
jsBool = jsAtom "false" (JSBool False)
     <|> jsAtom "true"  (JSBool True)

----------------------------------------------------------------

-- |
--
-- >>> parseJSON "  { \"key1\": 2 ,  \"key2\" : false } "
-- Right (JSObject [("key1",JSNumber 2),("key2",JSBool False)])
jsObject :: Parser JSON
jsObject = JSObject <$> betweenWs '{' kvs '}'
  where
    kvs = kv `sepBy` charWs ','
    kv = do
        JSString key <- jsString
        charWs ':'
        val <- jsValue
        return (key, val)

----------------------------------------------------------------

-- |
--
-- >>> parseJSON "  [ 1 , \"foo\" ,  true ] "
-- Right (JSArray [JSNumber 1,JSString "foo",JSBool True])
jsArray :: Parser JSON
jsArray = JSArray <$> betweenWs '[' vals ']'
  where
    vals = jsValue `sepBy` charWs ','

----------------------------------------------------------------

-- | Integer only.
--
-- >>> parseJSON "  123 "
-- Right (JSNumber 123)
-- >>> parseJSON "  -456 "
-- Right (JSNumber (-456))
jsNumber :: Parser JSON
jsNumber = JSNumber <$> do
    sign <- option id (negate <$ char '-')
    ns   <- many1 $ oneOf ['0'..'9']
    ws
    return $ sign $ fromInts ns
  where
    fromInts = foldl' (\x y -> x*10 + toInt y) 0
    toInt n = ord n - ord '0'

----------------------------------------------------------------

-- | Non Unicode only.
--
-- >>> parseJSON " \"foo bar baz\"  "
-- Right (JSString "foo bar baz")
jsString :: Parser JSON
jsString = JSString <$> (between (char '"') (char '"') (many jsChar) <* ws)
  where
    jsChar = unescaped <|> escaped
    unescaped = noneOf "\"\\"
    escaped   = char '\\' *> escapedChar

escapedChar :: Parser Char
escapedChar = choice $ map ch alist
  where
    ch (x,y) = y <$ char x
    alist = [
        ('b', '\b')
      , ('f', '\f')
      , ('n', '\n')
      , ('r', '\r')
      , ('t', '\t')
      , ('\\','\\')
      , ('\"','\"')
      ]

----------------------------------------------------------------

ws :: Parser ()
ws = void $ many $ oneOf " \t\r\n"

jsAtom :: String -> JSON -> Parser JSON
jsAtom str val = val <$ (string str <* ws)

charWs :: Char -> Parser ()
charWs c = char c *> ws

betweenWs :: Char -> Parser a -> Char -> Parser a
betweenWs o vals c = charWs o *> vals <* charWs c