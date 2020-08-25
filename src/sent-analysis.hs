import Data.List
import System.Environment
import Text.Printf

--Configurações do DataType a ser ultilizado
data Sent = Sent { begin::Int,
                   end::Int,
                   tool::[String]} deriving (Show)

instance Eq Sent where
    x == y = and (begin x == begin y,end x == end y)

instance Ord Sent where
    compare x y = compare ((begin x,end x)) ((begin y,end y))
    (<=) x y = or [begin x <= begin y,and (begin x == begin y, end x <= end y)]

--Funções auxiliares de processamento do DataType
ordena :: Sent -> [Sent] -> [Sent]
ordena n [] = [n]
ordena n (x:xs) | n<x = n:x:xs
                | otherwise = x:ordena n xs

merge :: Sent -> [Sent] -> [Sent]
merge s [] = [s]
merge s (x:xs) | s<x = s:x:xs
               | s==x = (Sent (begin x) (end x) (tool x ++ tool s)):xs
               | otherwise = x:merge s xs

intercept :: [Sent] -> Int -> [Sent]
intercept [] _ = []
intercept (x:xs) tam = if length(tool x)==tam then (Sent (begin x) (end x) []):intercept xs tam else intercept xs tam

diff :: [Sent] -> Int -> [Sent]
diff [] _ = []
diff (x:xs) tam = if length(tool x)<tam then x:diff xs tam else diff xs tam

--Funções auxiliares de conversão de arquivos
remove :: String -> Char -> String
remove [] _ = []
remove (x:xs) c | x==c = ""
                | otherwise = x:remove xs c

takename :: String -> String
takename str = tool where
    x = remove str '.'
    tool = reverse (remove (reverse x) '-')

file2sent :: String -> String -> [Sent]
file2sent str ext = lista where
    leitura = [[read e :: Int |e <- words l] |l <- lines str]
    lista = [Sent (element!!0) (element!!1) [ext] |element <- leitura]    

sentGenerator :: [String] -> [String] -> [Sent]
sentGenerator [] _ = []
sentGenerator (x:xs) (y:ys) = (file2sent x y) ++ (sentGenerator xs ys)

--Função de exibição da lista de Sent em tuplas
imprime :: [Sent] -> IO ()
imprime (x:xs) = do
    putStrLn (show (begin x)++" "++show (end x)++" "++(intercalate " " (tool x)))
    if xs/=[] then imprime xs else return()

--Chamar simplifica pra lista de Sent para gerar resultado final (usa as auxiliares)
simplifica :: [Sent] -> [Sent]
simplifica l = foldr merge [] $ foldr ordena [] l

--Função Main. Chamar código com nome dos arquivos como parâmetros
main :: IO ()
main = do

    args <- getArgs
    lista <- mapM readFile args
    let tools = [takename x | x <- args]
    let toolnum = length tools
    let universe = simplifica (sentGenerator lista tools)
    let shared = intercept universe toolnum
    let different = diff universe toolnum
    putStrLn "SENT:\n"
    imprime shared
    putStrLn "\nDIFF:\n"
    imprime different