import Appos hiding (main)
import Conllu.Data.Lexicon hiding (main)
import Conllu.IO hiding (main)
import Conllu.Type
import Conllu.Diff hiding (main)

import qualified Data.Map.Strict as M
import System.Environment

tokenizations :: M.Map String [String]
tokenizations =
  M.fromList
    [ ("dos", ["de", "os"])
    , ("do", ["de", "o"])
    , ("da", ["de", "a"])
    , ("das", ["de", "as"])
    , ("nos", ["em", "os"])
    , ("nas", ["em", "as"])
    , ("no", ["em", "o"])
    , ("na", ["em", "a"])
    , ("ao", ["a", "o"])
    , ("aos", ["a", "os"])
    , ("pelo", ["por", "o"])
    , ("à", ["a", "a"])
    , ("às", ["a", "as"])
    , ("pela", ["por", "as"])
    ]

main :: IO ()
main = do
  [dicfp, fp1, fp2] <- getArgs
  names <- readLexAndTokenize dicfp tokenizations
  let tt = beginTTrie names
  ds1' <- readDirectory fp1
  ds2  <- readDirectory fp2
  let ds1 = map (actOnDocTks (correctTks tt . filter isSToken)) ds1'
      dd = zipWith diffDoc ds1 ds2
      add = map apposDocDiff dd
  putStrLn . show $ add
  return ()
