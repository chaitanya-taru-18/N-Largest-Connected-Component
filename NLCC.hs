-- Chaitanya Sanjay Taru

-- Union find algorithm is used to solve the problem.
-- Import the necessary functions from Data.List library.
import Data.List ( intercalate, intersect, partition, union)

isCommon :: Eq a => [a] -> [a] -> Bool
isCommon x y = not $ null $ x `intersect` y -- Check whether lists have more than one value in common.

findUnions :: Eq a => [[a]] -> [a]
findUnions (x1:x2:xs) = findUnions $ union x1 x2:xs -- Repeatedly join elements in the list of connected edges by taking union of them.
findUnions [x] = x
findUnions [] = []

connection :: Eq a => [[a]] -> [[a]]
connection (x:xs) = findUnions (x:edges) : nonEdges -- This functions will pass union lists of only connected edges, ignoring non-edges.
    where
        (edges, nonEdges) = partition (isCommon x) xs   -- Check whether the there is an intersection between to lists.
                                                        -- Only the values that are there in the intersection should be consider to join
                                                        -- and create list of all connected indices. 
connection [] = []

getUnions :: Eq a => [[a]] -> [[a]]
getUnions (x:xs) = y:getUnions ys -- This function will get all the unions only if there is a connected edge between indices.
    where
      (y:ys) = connection (x:xs) -- Check whether there is a connection between indices or not.
getUnions [] = []

finalUnionFind :: Eq a => [[a]] -> [[a]]
finalUnionFind pairedLists =  -- Club all the connected indices into one list.
    if pairedLists /= getUnions pairedLists -- Until we find the list of all connected components
        then finalUnionFind (getUnions pairedLists) -- Repeat the process of joining the lists.
    else pairedLists

possiblePairs :: Integral t => t -> [t] -> [(t, t)]
possiblePairs lengthOfRows l = -- Function to find all possible pairs of indices in the list.
    case l of 
        [] -> []
        x:xs -> finalPairs x xs lengthOfRows ++ possiblePairs lengthOfRows xs -- Concatenate tuples of pairs one by one to the list of possible pairs.

finalPairs :: Integral t => t -> [t] -> t -> [(t, t)]
finalPairs x l lengthOfRows = -- Filter out the not useful edges and select only those who fits the constraints.
    case l of 
        [] -> []
        y:ys -> 
            if (y - x == 1 && mod x lengthOfRows /= lengthOfRows-1 && mod y lengthOfRows /= 0) || (y - x == lengthOfRows) 
                -- Only tuples with adjacent indices and only those which have distance of lenght of row between them (for vertical pairs)
                -- in a pair will be pass further. i.e. only up, down, left and right side edges will be kept.
                then (x, y) : finalPairs x ys lengthOfRows  -- Call recursively to produce the list of useful tuples and return.
            else finalPairs x ys lengthOfRows -- iff it fits the constraints, save a tuple otherwise ignore.
       
traverseList :: Eq a => [a] -> a -> [Int]
traverseList l v = [x | x <- [0..length l-1], l !! x == v] -- Return the list of indices based on the value v.

nlcc :: Eq a => [[a]] -> a -> IO ()
nlcc l v = do
    let lengthOfRows = length $ head l -- Fetch the length of the row to find vertical edges in further part.
    let flattenedList = intercalate [] l -- Flatten the list using intercalate function.
    let pairedTuples = possiblePairs lengthOfRows (traverseList flattenedList v) -- Traverse the list and fetch the indices of given value v save them in a list. 
                                                                                 -- Pass the length of rows and traversed list to find possible pairs between indices.
                                                                                 -- We get the list of tuples.
    let pairedLists = map (\(a, b) -> [a, b]) pairedTuples -- To use Union Find we convert the list of tuples to list of lists.
    print $ maximum $ map length $ finalUnionFind pairedLists -- Using Union Find join the connected components and check the largest amongst them.
      