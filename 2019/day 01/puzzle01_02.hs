fuelReq :: Int -> Int
fuelReq m | m < 6 = 0
          | otherwise = go + fuelReq go
    where go = div m 3 - 2


main :: IO ()
main = do

    input <- readFile "day_01_01_input.txt"

    putStrLn . show . sum . map fuelReq . map (read :: String -> Int) . lines $ input
