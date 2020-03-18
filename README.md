# Fix

Fix.hs aims at showing the mechanics of the types of F-Algebras baesd on an example given in the following presentation:
https://bartoszmilewski.com/2017/02/28/f-algebras/


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
    
