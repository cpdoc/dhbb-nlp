import System.Environment
import Conllu.IO hiding (main)
import Conllu.Diff hiding (main)
import Conllu.Type
import Text.Parsec hiding (token)
import Text.Parsec.String
import Text.Parsec.Combinator
import Conllu.Parse

palDeprel :: Parser DepRel
palDeprel = do
  mdrs <- maybeEmpty $ sepBy1 deprel' (char '|')
  case mdrs of
    (Just drs) ->
      if APPOS `elem` (map fst drs)
        then do
          return $ Just (APPOS, "")
        else do
          return $ Just (head drs)
    Nothing -> do
      return Nothing
{-- for PALAVRAS
main :: IO ()
main = do
  fp1:fp2:ls <- getArgs
  d1 <- readConlluFileWith (parseC customC {_deprelP = palDeprel}) fp1
  d2 <- readConlluFile fp2
  putStrLn $ printDocDiff $ diffDocOn ls d1 d2
  return ()
--}

main :: IO ()
main = do fp1:fp2:ls <- getArgs
          d1 <- readConlluFile fp1
          d2 <- readConlluFile fp2
          putStrLn $ printDocDiff $ diffDocOn ls d1 d2
          return ()
