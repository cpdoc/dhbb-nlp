
-- import Data.List
-- import System.FilePath.Posix

data Sent = Sent { begin::Int,
                     end::Int,
                     tool::[String]} deriving (Show)

instance Eq Sent where
    x == y = and (begin x == begin y,end x == end y)

instance Ord Sent where
    compare x y = compare ((begin x,end x)) ((begin y,end y))
    (<=) x y = or [begin x <= begin y,and (begin x == begin y, end x <= end y)]

ordena :: Sent -> [Sent] -> [Sent]
ordena n [] = [n]
ordena n (x:xs) | n<x = n:x:xs
                | otherwise = x:ordena n xs

merge :: Sent -> [Sent] -> [Sent]
merge s [] = [s]
merge s (x:xs) | s<x = s:x:xs
               | s==x = (Sent (begin x) (end x) (tool x ++ tool s)):xs
               | otherwise = x:merge s xs

simplifica :: [Sent] -> [Sent]
simplifica l = foldr merge [] $ foldr ordena [] l




-- file2sent :: String -> IO [Sent]
-- file2sent file = do
--     a <- readFile file
--     let b = lines a
--     return b


main :: IO ()
main = do
    -- let l = [Sent 0 2 ["b"], Sent 3 4 ["b"],Sent 0 1 ["a"],Sent 1 2 ["a"],Sent 3 4 ["a"]]
    -- print $ simplifica l
    -- s1 <- readFile "test-op.sent"
    -- let a = lines s1
    -- let b = map (words) a
    -- let c = (read x :: Int | x <- b)
    -- print b



    print 0