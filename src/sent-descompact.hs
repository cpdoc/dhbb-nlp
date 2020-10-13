-- run from inside /src/ giving as argument the filepath to be processed

import Data.List
import Data.Char
import System.Environment
import Text.ParserCombinators.ReadP

-- Parser to break file into tuples like (bebin,end,tools)
digits :: ReadP (Int,Int,String) 
digits = do
    n1 <- munch isDigit
    munch isSpace
    n2 <- munch isDigit
    char ' '
    t <- munch (\c -> c /= '\n')
    string "\n"
    return (read n1,read n2, t)

-- Parser to break reversed filename into (path,name,ext) 
filename :: ReadP (String,String,String) 
filename = do
    ext <- munch (\char -> char /= '.')
    char '.'
    name <- munch isDigit
    path <- munch (\c -> c /= ' ') 
    return (reverse path,reverse name, reverse ext)

convertOffset :: String -> (Int,Int,String) -> String
convertOffset str (b,e,_) = take (e-b) $ drop (b) str

convertDiff :: String -> (Int,Int,String) -> String
convertDiff str (b,e,t) = t++": "++(take (e-b) $ drop (b) str)

main = do
    args <- getArgs
    content <- readFile $ head args
    let (path,name,ext) = fst $ head $ readP_to_S filename $ reverse $ head args
        lst = fst(last(readP_to_S  (many $ digits) content))
    raw <- readFile $ "../raw/"++name++".raw"
    let s = [f raw x | x <- lst] where f = if ext=="offset" then convertOffset else convertDiff
    writeFile (path++name++".sent") $ intercalate "\n" s
