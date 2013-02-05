{-# LANGUAGE GADTs #-}

data Closure a where
    Ptr  :: a -> Closure a
    -- ^ This should be a function, but not applied to any arguments
    (:@) :: Closure (a -> b) -> a -> Closure b

infixl :@

-- Witnesses of concrete (monomorphic) non-function types
data Concrete a where
    IntConcrete :: Concrete Int

evalConcrete :: Concrete a -> Closure a -> a
evalConcrete _ (Ptr x) = x
evalConcrete _ (Ptr f :@ u) = f u
evalConcrete _ (Ptr f :@ u :@ v) = f u v
evalConcrete _ (Ptr f :@ u :@ v :@ w) = f u v w
    -- ^ I guess you need to use type-level lists or so to do recursion here

map' :: Closure (a -> b) -> [a] -> [Closure b]
map' cl []     = []
map' cl (x:xs) = cl :@ x : map' cl xs

addOne :: Closure (Int -> Int)
addOne = Ptr (+) :@ 1

test :: [Int]
test = map (evalConcrete IntConcrete) (map' addOne [1,2,3])

