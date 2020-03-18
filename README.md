# Fix

Fix.hs aims at showing the mechanics of the types of F-Algebras based on an example given in the following presentation:
https://bartoszmilewski.com/2017/02/28/f-algebras/

This seems to be complicated, but finding prime numbers, only requires one *single* line change based on Erathostene's filters compared to a simple identity.

The identity:

    coalg (p : ns)    =  StreamF p ns
    
[Erathostene's filters](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes)

    coalg (p : ns)    =  StreamF p (filter (notdiv p) ns) where notdiv p n = n `mod` p /= 0
    
It is amazing to have such a powerful result with so little customization of a general principle.

This is based on the fixed point of F-Albegras :

    data Fix f = Fx (f (Fix f))
    
This system is also using a hylomorphism, which is a composition of anamorphism followed by a catamaorphism. The mechanism allow to make programs in inductive form with no recusrive calls since by the use of the fixed point.

Find below a description of the tyep used in the example:


                                                                        a =  [2,3,4,5,6,7,8,9,10,11,12,13,14,15]
                                                                        a ::          [Int]
                                                                                        |
                                                                                      coalg
                                                                                        |
                                                                                        V
                                                                           StreamF 2 [3,5,7,9,11,13,15]
                                                                    coalg :: [Int] -> StreamF Int [Int]
                                                                                        |
                                                                                (fmap (ana coalg))
                                                                                        |
                                                                                        V
                                               (fmap (ana coalg)) . coalg :: [Int] -> StreamF Int (Fix (StreamF Int))
                                                                                        |
                                                                                        Fx
                                                                                        |
                                                                                        V
                                          Fx . (fmap (ana coalg)) . coalg :: [Int] -> Fix (StreamF Int)
                                                                                        |
                                                                                      unFix
                                                                                        |
                                                                                        V
                                  unFix . Fx . (fmap (ana coalg)) . coalg :: [Int] -> StreamF Int (Fix (StreamF Int))
                                                                                        |
                                                                                (fmap (cata alg))
                                                                                        |
                                                                                        V
                                                                             StreamF 2 [3,5,7,11,13]
              (fmap (cata alg)) . unFix . Fx . (fmap (ana coalg)) . coalg :: [Int] -> StreamF Int [Int]
                                                                                        |
                                                                                       alg
                                                                                        |
                                                                                        V
                                                                                 [2,3,5,7,11,13]
        alg . (fmap (cata alg)) . unFix . Fx . (fmap (ana coalg)) . coalg :: [Int] -> [Int]
                                                 (cata alg) . (ana coalg) :: [Int] -> [Int]
                                             ((cata alg) . (ana coalg)) a :: [2,3,5,7,11,13]
    (alg . (fmap (cata alg)) . unFix . Fx . (fmap (ana coalg)) . coalg) a :: [2,3,5,7,11,13]
    
