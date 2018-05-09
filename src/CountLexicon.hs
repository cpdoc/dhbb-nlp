module Main where

import           Conllu.Type
import           Conllu.Data.Lexicon hiding (main)
import           Conllu.IO hiding (main)

import qualified Data.Map.Strict as M
import           Data.Maybe
import           System.Environment

recLexFile :: M.Map String [String] -> TTrie -> FilePath -> IO ()
recLexFile toks tt fp = do
  d <- readConlluFile fp
  let stkss = map sentSTks $ _sents d
  mapM_
    (\stks ->
               mapM_ (putStrLn . show . map (fromMaybe "" . _form)) $
               recTks tt stks)
    stkss
  return ()

main :: IO ()
main = do
  (toks':dicfp:fps) <- getArgs
  toks <- readFile toks'
  let tokenizations = M.fromList . map readTokenization $ lines toks
  names <- readLexAndTokenize dicfp tokenizations
  let tt = beginTTrie names
  mapM_ (recLexFile tokenizations tt) fps
  return ()
