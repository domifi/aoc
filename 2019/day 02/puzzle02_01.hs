main :: IO ()
main = do

    input <- readFile "day_02_01_input.txt"

    let parsedInput = map (read :: String -> Int) . splitComma . head . lines $ input

    let fixedInput = listMap [id, const 12, const 2] parsedInput

    --putStrLn . show $ parsedInput
    putStrLn . show . head . execLoop $ fixedInput


splitComma :: String -> [String]
splitComma ws = map reverse . reverse $scHelp ws [[]]
    where
        scHelp [] ys = ys
        scHelp (x:xs) n@(y:ys) | x == ','  = scHelp xs ([]:n)
                               | otherwise = scHelp xs ((x:y):ys)

-- only works if the type doesn't need to change
listMap :: [a -> a] -> [a] -> [a]
listMap _  [] = []
listMap [] xs = xs
listMap (f:fs) (x:xs) = (f x) : (listMap fs xs)

-- opcode position -> Int list -> modified Int list
exec :: Int -> [Int] -> [Int]
exec _ [] = []
exec pos xs | readOp == 1  = compute (+)
            | readOp == 2  = compute (*)
            | readOp == 99 = xs
            | otherwise    = error $"unkown opcode at " ++ (show pos) ++ "\n" ++ (show (zip (take (length xs) [0..]) xs))
    where
        writePos = xs !! (pos + 3)
        readA    = deref $xs !! (pos + 1)
        readB    = deref $xs !! (pos + 2)
        readOp   = xs !! pos
        deref    = (!!) xs
        compute f = write writePos (f readA readB) xs


write :: Int -> a -> [a] -> [a] 
write i a ls
    | i < 0 = ls
    | otherwise = go i ls
  where
    go 0 (_:xs) = a : xs
    go n (x:xs) = x : go (n-1) xs
    go _ []     = []

execLoop :: [Int] -> [Int]
execLoop ys = execHelp ys 0
    where
        execHelp xs pos | xs !! pos == 99 = xs
                        | otherwise       = execHelp (exec pos xs) (pos + 4)

test1, test2 :: [Int]
test1 = [1,9,10,3,2,3,11,0,99,30,40,50]
test2 = [1,0,0,0,99]