main :: IO ()
main = do

    input <- readFile "day_02_01_input.txt"

    let parsedInput = map (read :: String -> Int) . splitComma . head . lines $ input

    let fixedInput = listMap [id, const 12, const 2] parsedInput

    print . calcNounVerb . findWords $ fixedInput


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


execLoop :: [Int] -> [Int]
execLoop ys = execHelp ys 0
    where
        execHelp xs pos | xs !! pos == 99 = xs
                        | otherwise       = execHelp (exec pos xs) (pos + 4)


write :: Int -> a -> [a] -> [a] 
write i a ls
    | i < 0 = ls
    | otherwise = go i ls
  where
    go 0 (_:xs) = a : xs
    go n (x:xs) = x : go (n-1) xs
    go _ []     = []

input :: [Int]
input = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,10,1,19,1,5,19,23,1,23,5,27,2,27,10,31,1,5,31,35,2,35,6,39,1,6,39,43,2,13,43,47,2,9,47,51,1,6,51,55,1,55,9,59,2,6,59,63,1,5,63,67,2,67,13,71,1,9,71,75,1,75,9,79,2,79,10,83,1,6,83,87,1,5,87,91,1,6,91,95,1,95,13,99,1,10,99,103,2,6,103,107,1,107,5,111,1,111,13,115,1,115,13,119,1,13,119,123,2,123,13,127,1,127,6,131,1,131,9,135,1,5,135,139,2,139,6,143,2,6,143,147,1,5,147,151,1,151,2,155,1,9,155,0,99,2,14,0,0]

initMemory :: Int -> Int -> [Int] -> [Int]
initMemory noun verb = listMap [id, const noun, const verb]

findWords :: [Int] -> [Int]
findWords ls = head . dropWhile ((/= 19690720) . head) $map execLoop [ initMemory noun verb ls | noun <- [0..99], verb <- [0..99]]

calcNounVerb :: [Int] -> Int
calcNounVerb (_:noun:verb:_) = 100 * noun + verb
