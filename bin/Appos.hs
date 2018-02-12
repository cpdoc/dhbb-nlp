import Conllu.Diff hiding (main)
import Conllu.IO hiding (main)
import Conllu.Type
import Conllu.Utils

import Data.Function
import Data.Maybe
import Prelude hiding (readFile)
import System.Environment

data ApposA
  = Correct
  | ErrDep
  | ErrHead
  | ErrNotA
  | ErrMissingA
  deriving (Eq, Show)

apposSTkDiff :: Token -> Token -> Maybe (Index, ApposA)
apposSTkDiff t1 t2 =
  let a1 = depIs APPOS t1
      a2 = depIs APPOS t2
      ix = _ix t1
  in case (a1, a2) of
       (True, True) -> Just $ (ix, apposIndeed t1 t2)
       (_, True)    -> Just $ (ix, apposMissing t1 t2)
       (True, _)    -> Just $ (ix, ErrNotA)
       _            -> Nothing

apposIndeed :: Token -> Token -> ApposA
apposIndeed t1 t2 =
  if t1 `sameHead` t2
    then Correct
    else ErrHead

apposMissing :: Token -> Token -> ApposA
apposMissing t1 t2 =
  if t1 `sameHead` t2
    then ErrDep
    else ErrMissingA

sameHead :: Token -> Token -> Bool
sameHead = equal `on` _dephead

apposSentDiff :: SentDiff -> (Index, [(Index, ApposA)])
apposSentDiff = applyWithLabel (catMaybes . map (uncurry apposSTkDiff))

apposDocDiff :: DocDiff -> (String, [(Index, [(Index, ApposA)])])
apposDocDiff = applyWithLabel (map apposSentDiff)

main :: IO ()
main = do
  [fp1, fp2] <- getArgs
  d1 <- readConlluFile fp1
  d2 <- readConlluFile fp2
  let dd = diffDoc d1 d2
      add = apposDocDiff dd
  print add
  return ()
