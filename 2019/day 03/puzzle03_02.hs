main :: IO ()
main = do

    input <- readFile "day_03_01_input.txt"
    --input <- readFile "daytestinput.txt"

    let parsedInput = map (map readWirePath . splitComma) . lines $ input

    let pointLists = map wirePathToCoords parsedInput
    let pointsA = pointLists !! 0
    let pointsB = pointLists !! 1

    let intersects = intersectLists pointLists

    print . minimum $ zipWith (+) (distToIntersect intersects pointsA) (distToIntersect intersects pointsB)

    
splitComma :: String -> [String]
splitComma ws = map reverse . reverse $scHelp ws [[]]
    where
        scHelp [] ys = ys
        scHelp (x:xs) n@(y:ys) | x == ','  = scHelp xs ([]:n)
                               | otherwise = scHelp xs ((x:y):ys)

manDist :: Num a => (a,a) -> (a,a) -> a
manDist (a,b) (c,d) = abs (a - c) + abs (b - d)


-- ############### WirePath parser BEGIN

data WirePath = L Int
              | R Int
              | U Int
              | D Int
              | WirePath :-: WirePath
              | EmptyWire
    deriving (Eq)

infixr 5 :-:

wireAppend :: WirePath -> WirePath -> WirePath
wireAppend a EmptyWire = a
wireAppend EmptyWire a = a
wireAppend a b         = a :-: b

instance Show WirePath where
    show = showWirePath

showWirePath :: WirePath -> String
showWirePath (L a) = 'L' : show a
showWirePath (R a) = 'R' : show a
showWirePath (U a) = 'U' : show a
showWirePath (D a) = 'D' : show a
showWirePath (a :-: b) = showWirePath a ++ " " ++ showWirePath b

{--
instance Foldable WirePath where
    foldr f z = go
        where
            go EmptyWire = z
            go (a :-: b) = go (go a :-: go b)
            go a         = f a
--}
    

--instance Read WirePath where
--    readsPrec _ wp = [(readWirePath wp, "")]

readWirePath :: String -> WirePath
readWirePath [] = EmptyWire
readWirePath (x:xs) | x == 'L' = wireAppend (L go) (readWirePath xs)
                    | x == 'R' = wireAppend (R go) (readWirePath xs)
                    | x == 'U' = wireAppend (U go) (readWirePath xs)
                    | x == 'D' = wireAppend (D go) (readWirePath xs)
                    | otherwise = readWirePath $dropWhile (`notElem` "LRUD") xs
    where
        go = readOneInt $ dropWhile (`notElem` "1234567890") xs


readOneInt :: String -> Int
readOneInt = readHelp []
    where
        readHelp xs []     = read $reverse xs
        readHelp xs (y:ys) | y `elem` "1234567890" = readHelp (y:xs) ys
                           | otherwise             = read $reverse xs

-- ############### WirePath parser END

wirePathToCoords :: [WirePath] -> [(Int,Int)]
wirePathToCoords = reverse . go []
    where
        go :: [(Int,Int)] -> [WirePath] -> [(Int,Int)]
        go []       (x:xs) = go (reverse $calcCoord (0,0) x) xs
        go n@(y:ys) (x:xs) = go ((reverse $calcCoord y x) ++ n) xs
        go n        []     = n

        calcCoord :: (Int, Int) -> WirePath -> [(Int,Int)]
        calcCoord (x,y) (L 0) = []
        calcCoord (x,y) (R 0) = []
        calcCoord (x,y) (U 0) = []
        calcCoord (x,y) (D 0) = []
        calcCoord (x,y) (L a) = (x-1,y)    : calcCoord (x-1, y) (L (a-1))
        calcCoord (x,y) (R a) = (x+1, y)   : calcCoord (x+1, y) (R (a-1))
        calcCoord (x,y) (U a) = (x,   y+1) : calcCoord (x, y+1) (U (a-1))
        calcCoord (x,y) (D a) = (x,   y-1) : calcCoord (x, y-1) (D (a-1))

intersect :: Eq a => [a] -> [a] -> [a]
intersect xs [] = []
intersect [] xs = []
intersect (x:xs) ys | x `elem` ys = x : intersect xs ys
                    | otherwise   = intersect xs ys

intersectLists :: Eq a => [[a]] -> [a]
intersectLists []  = []
intersectLists [x] = x
intersectLists (x:xs) = intersect x $intersectLists xs


-- list of intersects -> list of points -> steps to that point
distToIntersect :: [(Int,Int)] -> [(Int,Int)] -> [Int]
distToIntersect intersects points = map (flip getInd points) intersects


getInd :: Eq a => a -> [a] -> Int
getInd _ [] = error "Not in List! (getInd)"
getInd x (y:ys) | x == y = 1
                | otherwise = 1 + getInd x ys