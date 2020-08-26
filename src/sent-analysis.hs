-- após compilado, chamar como ./sent-analysis file1 file2 file3...
-- ele vai gerar os arquivos '.sent' e, se houver, '.diff' no
-- diretório do file1

import Data.List
import Data.Char
import System.Environment
import Text.Printf
import System.IO
import System.FilePath.Posix
import qualified Data.ByteString.Lazy.Char8 as LC
import Data.Maybe

-- configurações do DataType a ser ultilizado

data Sent = Sent { begin :: Int,
                   end   :: Int,
                   tool  :: [String]} deriving (Show)

instance Eq Sent where
    x == y = and (begin x == begin y,end x == end y)

instance Ord Sent where
    compare x y = compare ((begin x,end x)) ((begin y,end y))
    (<=) x y = or [begin x <= begin y, and (begin x == begin y, end x <= end y)]


--funções auxiliares de processamento do DataType

merge :: Sent -> [Sent] -> [Sent]
merge s [] = [s]
merge s (x:xs)
  | s < x     = s : x : xs
  | s == x    = (Sent (begin x) (end x) (tool x ++ tool s)) : xs
  | otherwise = x : merge s xs


intercept :: [Sent] -> Int -> [Sent]
intercept [] _ = []
intercept (x:xs) tam = if length(tool x) == tam then
  (Sent (begin x) (end x) []) : intercept xs tam else intercept xs tam


diff :: [Sent] -> Int -> [Sent]
diff [] _ = []
diff (x:xs) tam = if length(tool x)<tam then x:diff xs tam else diff xs tam


--Funções auxiliares de conversão de arquivos

split :: Char -> String -> [String]
split c xs = case break (==c) xs of 
  (ls, "") -> [ls]
  (ls, x:rs) -> ls : split c rs
  
takename fn = (split '-' (takeBaseName fn))!!1

parseLines :: LC.ByteString -> String -> [Sent]
parseLines content tool =
  map (\line ->
         let a = (LC.words line)
             begin = fst $ fromJust $ LC.readInt (a!!0)
             end   = fst $ fromJust $ LC.readInt (a!!1)
         in
           Sent begin end [tool])
  $ LC.lines content

-- cost of words+readInt vs. span+read? we should use parse
-- combinators anyway.
parseLine :: String -> (Int, Int)
parseLine str =
  let (digs1, rest1) = span isDigit str
      (_    , rest2) = span isSeparator rest1
      (digs2, rest3) = span isDigit str
      in
    (read digs1, read digs2)
  

sentGenerator :: [LC.ByteString] -> [String] -> [Sent]
sentGenerator [] _ = []
sentGenerator (x:xs) (y:ys) = (parseLines x y) ++ (sentGenerator xs ys)

-- função de exibição da lista de Sent em tuplas
imprime :: [Sent] -> [String]
imprime [] = []
imprime (x:xs) = str where
    str = [(show (begin x)++" "++show (end x)++" "++(intercalate " " (tool x)))] ++ (imprime xs)
    

-- chamar simplifica pra lista de Sent para gerar resultado final (usa as auxiliares)

simplifica :: [Sent] -> [Sent]
simplifica l = foldr merge [] $ sort l 


save :: [Char] -> [Sent] -> [Sent] -> IO()
save name shared [] =
  writeFile (name ++ ".sent") $ (intercalate "\n" (imprime shared)) ++ "\n"
save name shared diff =
  do
    writeFile (name ++ ".sent") $ (intercalate "\n" (imprime shared)) ++ "\n"
    writeFile (name ++ ".diff") $ (intercalate "\n" (imprime diff)) ++ "\n"

main :: IO ()
main = do
  args  <- getArgs
  contents <- mapM LC.readFile args
  let tools     = [takename x | x <- args]
      toolnum   = length tools
      name      = (split '-' $ takeBaseName (args!!0))!!0
      universe  = simplifica (sentGenerator contents tools)
      shared    = intercept universe toolnum
      different = diff universe toolnum in
    save name shared different
