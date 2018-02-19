module Main where

import           Conllu.Type
import           Conllu.Data.Lexicon hiding (main)
import           Conllu.IO hiding (main)

import qualified Data.Map.Strict as M
import           Data.Maybe
import           System.Environment

main :: IO ()
main = do
  (toks':dicfp:fps) <- getArgs
  toks <- readFile toks'
  let tokenizations = M.fromList . map readTokenization $ lines toks
  names <- readLexAndTokenize dicfp tokenizations
  let tt = beginTTrie names
  ds <- mapM readConlluFile fps
  mapM
    (\d ->
       let stkss = map sentSTks $ _sents d
       in mapM
            (\stks ->
               mapM_ (putStrLn . show . map (fromJust . _form)) $
               recTks tt stks)
            stkss)
    ds
  return ()
