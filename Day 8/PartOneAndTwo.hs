import Data.Map qualified as Map
import Data.Maybe (fromJust)
import Data.Text (replace)
import Data.Text qualified
import Debug.Trace (trace)
import Distribution.Compat.Graph (toMap)
import System.IO
  ( IOMode (ReadMode),
    hClose,
    hGetContents,
    openFile,
  )

remLast "" = ""
remLast cs = init cs

splitOn :: String -> String -> [String]
splitOn s = map Data.Text.unpack . Data.Text.splitOn (Data.Text.pack s) . Data.Text.pack

mapNodes :: String -> (String, (String, String))
mapNodes s = (head l, l3)
  where
    l = splitOn " = " s
    l2 = splitOn ", " (last l)
    l3 = (drop 1 $ head l2, remLast (last l2))

testF :: String -> Int -> Map.Map String (String, String) -> (String, (String, String)) -> Int -> ((String, (String, String)), Int, Int)
testF commands index nodesMap currentNode step =
  (newCurrent, newIndex, step + 1)
  where
    command = commands !! index
    newKey = if command == 'L' then fst $ snd currentNode else snd $ snd currentNode
    newValue = Map.lookup newKey nodesMap
    newCurrent = (newKey, fromJust newValue)
    newIndex = mod (index + 1) (length commands)

partOneCompare :: ((String, (String, String)), Int, Int) -> Bool
partOneCompare (node, index, _) = fst node == "ZZZ"

partTwoCompare :: ([(String, (String, String), Int)], Int, [Int]) -> Bool
partTwoCompare (nodes, index, _) = not $ any (\(key, _, _) -> last key /= 'Z') nodes

main = do
  handle <- openFile "input.txt" ReadMode
  contents <- hGetContents handle
  let l = lines contents
  let commands = head l
  let nodes = drop 2 l
  let nodesMap = Map.fromList $ map mapNodes nodes

  let filteredMap = map (\(key, value) -> (key, value, 0)) $ Map.toList $ Map.filterWithKey (\x y -> last x == 'A') nodesMap

  let untilInputPartOne = (("AAA", fromJust (Map.lookup "AAA" nodesMap)), 0, 0)

  let untilInputPartTwo = (filteredMap, 0, [])

  let resPartTwo = until partTwoCompare (\(nodes, index, counts) -> foldr ((\((nodeS, nodeE), index, count) (nodes, oldIndex, counts) -> (if last nodeS == 'Z' then nodes else nodes ++ [(nodeS, nodeE, count)], index, if last nodeS == 'Z' then counts ++ [count] else counts)) . (\(key, value, count) -> testF commands index nodesMap (key, value) count)) ([], 0, counts) nodes) untilInputPartTwo

  let resPartOne = until partOneCompare (\(x, y, z) -> testF commands y nodesMap x z) untilInputPartOne

  let (_, _, count) = resPartOne
  let (_, _, counts) = resPartTwo
  let h = head counts
  let t = tail counts
  let resPartTwo = foldr (\x old -> div (x * old) (gcd x old)) h t
  print "Part One: "
  print count
  print "Part Two: "
  print resPartTwo
  hClose handle
