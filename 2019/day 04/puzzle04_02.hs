import Data.List (group)

main :: IO ()
main = do

    -- input 165432-707912

    --print $ [ d | d <- [165432..707912]]
    print . length $ [ pw | pw <- [165432..707912], isCandidate pw]


isCandidate :: Int -> Bool
isCandidate n = hasExactDouble xs && rising xs
    where xs = intToIntList n

intToIntList :: Int -> [Int]
intToIntList n | n <= 9 = [n]
               | otherwise = intToIntList (n `div` 10) ++ [n `mod` 10]

hasDouble :: Eq a => [a] -> Bool
hasDouble []  = False
hasDouble [x] = False
hasDouble (x:y:xs) | x == y    = True
                   | otherwise = hasDouble (y:xs)

-- list has at least one occurrence of exactly 
hasExactDouble :: Eq a => [a] -> Bool
hasExactDouble = elem 2 . map length . group
--hasExactDouble (x:ls@(y:z:u:xs)) = y == z && 

rising :: Ord a => [a] -> Bool
rising []  = True
rising [x] = True
rising (x:y:xs) | x > y = False
                | otherwise = rising (y:xs)

xor :: Bool -> Bool -> Bool
xor a b = (a && not b) || (not a && b)