-- email subj: triplas appos
module Main where

import UD
import ConlluReader as CR hiding (main)
import NLP

import Data.Maybe
import Data.Tree
import System.Directory
import System.Environment
import System.FilePath
import Control.Monad

readDhbb :: Int -> FilePath -> IO [Document]
readDhbb 0 fp = return []
readDhbb n fp = do
  d <- CR.readFile $ fp </> ((show n :: FilePath) ++ ".conllu")
  ds <- readDhbb (n - 1) fp
  return (d : ds)

docToTrees :: Document -> [TTree]
docToTrees d = map (fst . toETree) $ sents d

getApposType :: Token -> String
getApposType t = takeWhile (/= '|') $ fromMaybe "" $ misc t

treeGetAppos :: TTree -> [(String,(String,String))]
treeGetAppos t =
  let ps = getRel APPOS t
      pss = map (mapP ttreeToStr) ps
      subs = map (getApposType . rootLabel . fst) ps
  in zip subs pss

tripleToStr :: (String, (String, String)) -> String
tripleToStr (a, (b, c)) = concat ["<<", a, "|", b, "|", c, ">>\n"]

---
-- main
main :: IO ()
main = do [n,fp] <- getArgs
          ds <- readDhbb (read n :: Int) fp
          let ts  = concatMap docToTrees ds
              trs = concatMap treeGetAppos ts
          putStrLn $ concatMap tripleToStr trs
