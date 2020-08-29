-- After compiling, execute as ./sent-analysis file1 file2 file3...

-- Script will produce the files '.sent' and, maybe, '.diff'
-- at the same path of file1.

import Data.List
import Data.Char
import System.Environment
import Text.ParserCombinators.ReadP

-- DataType setup
data Sent = Sent { begin :: Int,
                   end   :: Int,
                   tool  :: [String]} deriving (Show)

instance Eq Sent where
    x == y = and (begin x == begin y,end x == end y)

instance Ord Sent where
    compare x y = compare ((begin x,end x)) ((begin y,end y))
    (<=) x y = or [begin x <= begin y, and (begin x == begin y, end x <= end y)]

-- Parser to readd file content do Sent
getSents :: String -> String -> [Sent] 
getSents filecontent extension= l where
  tuples = fst (last (readP_to_S  (many $ digits) filecontent))
  l = map (\tuple -> Sent (fst tuple) (snd tuple) [extension]) tuples

digits :: ReadP (Int,Int) 
digits = do
    n1 <- munch isDigit
    munch isSpace
    n2 <- munch isDigit
    string "\n"
    return (read n1,read n2)

-- Parser to read filenames to prefix and sufix
getname :: String -> (String, String) 
getname str = fst $ head $ readP_to_S filename str

filename :: ReadP (String,String) 
filename = do
    prefix <- munch (\char -> char /= '-')
    char '-'
    sufix <- munch (\char -> char /= '.')
    string ".sent"
    return (prefix,sufix)

-- Convert file into Sent list
universe :: [String] -> [String] -> [Sent]
universe [] _ = []
universe (x:xs) (y:ys) = s ++ universe xs ys where
  (_,sufix) = getname y
  s = getSents x sufix

-- Merge sent to sent list updating tool list
merge :: Sent -> [Sent] -> [Sent]
merge s [] = [s]
merge s (x:xs)
  | s < x     = s : x : xs
  | s == x    = (Sent (begin x) (end x) (tool x ++ tool s)) : xs
  | otherwise = x : merge s xs

-- Separate intersection of tools from Sent list
intercept :: [Sent] -> Int -> [Sent]
intercept [] _ = []
intercept (x:xs) numtools = if length(tool x) == numtools then
  (Sent (begin x) (end x) []) : intercept xs numtools else intercept xs numtools

-- Separate divergence of tools from Sent list
differ :: [Sent] -> Int -> [Sent]
differ [] _ = []
differ (x:xs) numtools = if length(tool x)<numtools then x:differ xs numtools else differ xs numtools

-- Formats the sent list to strings to be written in file
format :: [Sent] -> [String]
format [] = []
format (x:xs) = [(show (begin x)++" "++show (end x)++" "++(intercalate " " (tool x)))] ++ (format xs)

-- Creates Sent list from files
files2sent x y = foldr merge [] $ sort $ universe x y

-- Save results to '.sent' and '.diff' files
save :: [Char] -> [Sent] -> [Sent] -> IO()
save name shared [] =
  writeFile (name ++ ".sent") $ (intercalate "\n" (format shared)) ++ "\n"
save name shared diff =
  do
    writeFile (name ++ ".sent") $ (intercalate "\n" (format shared)) ++ "\n"
    writeFile (name ++ ".diff") $ (intercalate "\n" (format diff)) ++ "\n"

main = do
  args <- getArgs
  contents <- mapM readFile args
  let sentlist = files2sent contents args
      numtools = length args
      eq = intercept sentlist numtools
      diff = differ sentlist numtools
      (path,_) = getname $ head args
  save path eq diff