# Fix

[Fix.hs](https://github.com/jdelouche/Fix/blob/master/Fix.hs) aims at showing the mechanics of the types of [F-Algebras](https://en.wikipedia.org/wiki/F-algebra) based on an example given in the following presentation:
https://bartoszmilewski.com/2017/02/28/f-algebras/

This seems to be complicated, but in this example finding prime numbers only requires *one single line change* compared to a simple identity.

The identity:

    coalg (p : ns)    =  StreamF p ns
    
[Erathostene's filters](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes):

    coalg (p : ns)    =  StreamF p (filter (notdiv p) ns) where notdiv p n = n `mod` p /= 0
    
It is amazing to have such a powerful result with so little customization of a general principle.

And this is solely based on the fixed point of F-Albegras :

    data Fix f = Fx (f (Fix f))
    
In comparison, a fixed point for functions is determined by the equation : x = f x. For algebraic data types, it is proposed the above.

The system is using a [hylomorphism](https://en.wikipedia.org/wiki/Hylomorphism_(computer_science)), a composition of an anamorphism and a catamorphism. This mechanism surprisingly allows to write inductive programs with no recusrive calls, thanks to the use of the recursive struture of the fixed point.

Programs are so easy to write that I decided to use this paradigm extensively in my pet project of [text musical notation](https://github.com/jdelouche/hmusic/blob/master/src/Data/Amp/Music/Midi/Midi.hs) and also to [monitor cpu activity on Linux](https://github.com/jdelouche/hproc/blob/master/src/Hproc/Hproc.hs).

No monads ! A strong point of simplification thanks to the data types construction/deconstruction which allows to avoid the much feared and [cumbersome Monads](https://github.com/jdelouche/FeelAndSeeHaskellBasics/blob/master/FeelandSeeHaskellBasics.pdf), the mechanism is based only on function compositions. Of course, except for some functors not havving deconstrution like the IO Monad.

Find below a description of the types used in this example:


    -- Ref to  https://bartoszmilewski.com/2017/02/28/f-algebras/
                                                                        a =  [2,3,4,5,6,7,8,9,10,11,12,13,14,15]
                                                                        a ::               [Int]
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
    
