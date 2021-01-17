import System.Environment ( getArgs )
import System.Exit ( ExitCode(ExitSuccess), exitWith )
import Data.List ( intercalate )
import Text.ParserCombinators.ReadP ( char, many, munch, readP_to_S, string, ReadP )
import Data.Char ( isDigit, isSpace )
import System.FilePath ( takeExtension )

usage = putStrLn "Usage:\n./sent-convert path-in raw-file => descompact offset into sent on stdout\n./sent-convert -c path-in path-out => compact sent into offset/goffset"
exit = exitWith ExitSuccess

parse ["-h"] = usage   >> exit
parse ("-c" : ls) = compact ls >> exit
parse ls     = descompact ls >> exit


-- Sentences parser
sent :: ReadP (Int)
sent = do
    s <- munch (\c -> c /= '\n')
    string "\n"
    return (length s)
   
-- Compact sent file to offset style file
compact :: [FilePath] -> IO ()
compact ls = do
    c <- readFile $ ls !! 0
    let lst = fst $ last $ readP_to_S (many $ sent) c
    let l = tail $ foldl aux [(0,-1)] lst where
        aux prev len = do
            let (_,e) = last prev
            prev++[(e+1,e+1+len)]
    let s = map (\x -> show(fst x) ++" "++show(snd x)++" ") l
    writeFile (ls !! 1) $ intercalate "\n" s ++ "\n"


-- Parser to offset like files
digits :: ReadP (Int,Int,String) 
digits = do
    n1 <- munch isDigit
    munch isSpace
    n2 <- munch isDigit
    char ' '
    t <- munch (\c -> c /= '\n')
    string "\n"
    return (read n1,read n2, t)

-- Descompact offset like file to sentences
descompact :: [FilePath] -> IO ()
descompact ls = do
    content <- readFile $ ls !! 0
    let lst = fst(last(readP_to_S  (many $ digits) content))
    raw <- readFile $ ls !! 1
    let s = [f raw x | x <- lst] where
        convertOffset str (b,e,_) = take (e-b) $ drop (b) str
        convertDiff str (b,e,t) = t++": "++(take (e-b) $ drop (b) str)
        f = if (takeExtension $ ls !! 0)==".diff" then convertDiff else convertOffset
    putStrLn $ intercalate "\n" s


main = getArgs >>= parse