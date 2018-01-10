-- email subj: triplas appos
module Main where

import UD
import ConlluReader as CR hiding (main)

import System.Directory
import System.Environment
import System.FilePath
import Control.Monad

readDhbb :: Int -> IO [Document]
readDhbb 0 = do return []
readDhbb n = do d <- CR.readFile $ "/home/bruno/git/dhbb-nlp/udp/" </> ((show n :: FilePath) ++ ".conllu")
                ds <- readDhbb (n - 1)
                return $ (d:ds)

docToTrees :: Document -> (String,[TTree])
docToTrees d = let ts = map (fst . toETree) $ sents d
                   f  = file d
               in (d,ts)

--extractRelation :: Pos -> TTree
--extractRelation pos tt = foldMap

--findRelation :: Dep -> TTree
--findRelation dep tt = mfilter tt

main :: IO ()
main = do [n] <- getArgs
          ds <- readDhbb (read n :: Int)
          putStr $ show ds
