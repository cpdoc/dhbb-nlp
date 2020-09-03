import Data.List
import Data.Char
import System.Environment
import Text.ParserCombinators.ReadP

-- Parser to break file into tuples like (bebin,end)
digits :: ReadP (Int,Int) 
digits = do
    n1 <- munch isDigit
    munch isSpace
    n2 <- munch isDigit
    munch (\c -> c /= '\n')
    string "\n"
    return (read n1,read n2)

-- Parser to break reversed filename into (path,name,ext) 
filename :: ReadP (String,String,String) 
filename = do
    ext <- munch (\char -> char /= '.')
    char '.'
    name <- munch isDigit
    path <- munch (\c -> c /= ' ') 
    return (reverse path,reverse name, reverse ext)

convert :: String -> (Int,Int) -> String
convert str (b,e) = take (e-b) $ drop (b) str

main = do
    args <- getArgs
    content <- readFile $ head args
    let (path,name,ext) = fst $ head $ readP_to_S filename $ reverse $ head args
        lst = fst(last(readP_to_S  (many $ digits) content))
    raw <- readFile $ "../raw/"++name++".raw"
    let s = [convert raw x | x <- lst]
    writeFile (path++name++".sent") $ intercalate "\n" s