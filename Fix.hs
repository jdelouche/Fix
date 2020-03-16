{-# LANGUAGE DeriveFunctor #-}
--  https://bartoszmilewski.com/2017/02/28/f-algebras/
import Prelude
import Data.Typeable
import Text.Printf
data Fix f = Fx (f (Fix f))
unFix :: Fix f -> f (Fix f) 
unFix (Fx f) = f
ana :: ([Int]->StreamF Int [Int]) -> ([Int] -> Fix (StreamF Int))
ana coalgF = Fx   . (fmap (ana coalgF)) . coalgF
cata :: ((StreamF Int [Int])->[Int]) -> (Fix (StreamF Int) -> [Int])
cata algF  = algF . (fmap (cata  algF)) . unFix
data StreamF e a = NilF | StreamF e a deriving (Functor,Show)
coalg :: [Int]->StreamF Int [Int]
coalg []          =  NilF
coalg (p : ns)    =  StreamF p ns
-- coalg (p : ns)    =  StreamF p (filter (notdiv p) ns) where notdiv p n = n `mod` p /= 0
alg   :: StreamF Int [Int]->[Int]
alg NilF = []
alg (StreamF e a)  = e:a
showType
  :: (PrintfArg t, Show a1, Typeable a2) => a1 -> t -> a2 -> String
showType s n f = printf ("%"++(show s)++"s :: %s") n (show (typeOf f))
showFunction :: Integer -> String -> IO ()
showFunction l n = do
    printf ("%"++(show l)++"s\n") "|"
    printf ("%"++(show l)++"s\n") n
    printf ("%"++(show l)++"s\n") "|"
    printf ("%"++(show l)++"s\n") "V"
main :: IO ()
main      = do
    let a = [2..10]
    putStr          "                                                                    a =  "
    print                                                                                a
    putStr          "                                                                    a ::          "
    print $ typeOf $                                                                     a
    showFunction 85 "coalg"
    putStr          "                                                                coalg :: "
    print $ typeOf $                                                                 coalg
    showFunction 85 "(fmap (ana coalg))"
    putStr          "                                           (fmap (ana coalg)) . coalg :: "
    print $ typeOf $                                            (fmap (ana coalg)) . coalg
    putStr          "                                      Fx . (fmap (ana coalg)) . coalg :: "
    print $ typeOf $                                       Fx . (fmap (ana coalg)) . coalg
    putStr          "                              unFix . Fx . (fmap (ana coalg)) . coalg :: "
    print $ typeOf $                               unFix . Fx . (fmap (ana coalg)) . coalg
    putStr          "          (fmap (cata alg)) . unFix . Fx . (fmap (ana coalg)) . coalg :: "
    print $ typeOf $           (fmap (cata alg)) . unFix . Fx . (fmap (ana coalg)) . coalg
    putStr          "    alg . (fmap (cata alg)) . unFix . Fx . (fmap (ana coalg)) . coalg :: "
    print $ typeOf $     alg . (fmap (cata alg)) . unFix . Fx . (fmap (ana coalg)) . coalg
    putStr          "                                             (cata alg) . (ana coalg) :: "
    print $ typeOf $                                              (cata alg) . (ana coalg)
    putStr          "                                         ((cata alg) . (ana coalg)) a :: "
    print $                                                   ((cata alg) . (ana coalg)) a
    putStr          "(alg . (fmap (cata alg)) . unFix . Fx . (fmap (ana coalg)) . coalg) a :: "
    print $          (alg . (fmap (cata alg)) . unFix . Fx . (fmap (ana coalg)) . coalg) a
