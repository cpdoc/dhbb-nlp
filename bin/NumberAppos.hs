import Conllu.IO hiding (main)
import Conllu.Type

import System.Environment
import Data.List

main :: IO ()
main = do
  fps <- getArgs
  ds <- mapM readConlluFile fps
  mapM_
    (\d ->
       mapM_
         (\s ->
            if any (\t -> isSToken t && depIs APPOS t) $ _tokens s
              then putStrLn $ show s
              else return ()) $
       _sents d)
    ds
  return ()
