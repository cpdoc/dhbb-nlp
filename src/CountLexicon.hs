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
       let stkss =
             map (\s -> (snd . head $ _meta s, sentSTks s)) $ _sents d
       in do putStrLn $ _file d
             mapM
               (\(sid, stks) -> do
                  putStr (sid ++ ":")
                  mapM_ (putStrLn . show . map (fromMaybe "" . _form)) $
                    recTks tt stks)
               stkss)
    ds
  return ()
