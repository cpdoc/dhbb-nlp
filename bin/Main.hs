-- email subj: triplas appos
module Main where

import Conllu.Data.Token
import Conllu.Data.Tree
import Conllu.IO as CR hiding (main)
import Conllu.Type

import Control.Monad
import Data.List
import Data.Maybe
import Data.Tree
import System.Directory
import System.Environment
import System.FilePath

readDhbb :: Int -> FilePath -> IO [Document]
readDhbb 0 fp = return []
readDhbb n fp = do
  d <- CR.readFile $ fp </> ((show n :: FilePath) ++ ".conllu")
  ds <- readDhbb (n - 1) fp
  return (d : ds)

docToTrees :: Document -> (String, [(String, [Token])])
docToTrees Document {_file = fid, _sents = ss} =
  let ids =
        map (fromMaybe "no-id" . lookup "sent_id " . _meta) ss
      tss = map sentSTks ss
  in (fid, zip ids tss)

getApposType :: Token -> String
getApposType t =
  let st = takeWhile (/= '|') $ fromMaybe "" $ _misc t
  in if elem '&' st
       then st
       else "NA"

getDHBBRel :: [Token] -> [(TTree, TTree)]
getDHBBRel ts =
  getRel3
    (depIs APPOS)
    (\tr t ->
       fromJust $ rmSubTreesBy
        (\t' -> (((not $ relIsNominal t') ||
           (_ix t == _ix t')) && (_ix t' /= _depheadU t))) $
         getIxSubTree (_depheadU t)
         tr)
    (\tr t ->
       fromJust $ rmSubTreesBy (not . relIsNominal) $
       getIxSubTree (_ix t) tr)
    ts

relIsNominal :: Token -> Bool
relIsNominal t = any (\d -> depIs d t)
  [NSUBJ,NMOD,APPOS,NUMMOD,ACL,AMOD,DETdr,CLF,CASE,CONJ,CC,FIXED,FLAT
  ,COMPOUND,LIST,PARATAXIS,ORPHAN,GOESWITH]

tksGetAppos :: [Token] -> [(String, (String, String))]
tksGetAppos ts =
  let ps = getDHBBRel ts
      pss = map (mapP tTreeToStr) ps
      subs = map (getApposType . rootLabel . snd) ps
  in zip subs pss

tripleToStr :: String -> (String, (String, String)) -> String
tripleToStr l (a, (b, c)) = concat [l, "|", a, "|", b, "|", c, "\n"]

---
-- main
main :: IO ()
main = do
  [n, fp] <- getArgs
  ds <- readDhbb (read n :: Int) fp
  let llts = map docToTrees ds
      lltrs = map tksGetAppos' llts
  putStrLn $ concatMap tripleToStr' lltrs
  where
    tksGetAppos' (fid, sps) = (fid, map tksGetAppos'' sps)
    tksGetAppos'' (sid, ts) = (sid, tksGetAppos ts)
    tripleToStr' (fid, sps) = concatMap (tripleToStr'' fid) sps
    tripleToStr'' fid (sid, ts) =
      if null ts
        then []
        else concatMap (tripleToStr (fid ++ "|" ++ sid)) ts
