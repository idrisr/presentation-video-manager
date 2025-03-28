module Main (main) where

import DFA
import Test.Tasty
import Test.Tasty.HUnit

tests :: TestTree
tests = testGroup "" [testRename]

testRename :: TestTree
testRename =
    testGroup
        ""
        $ let f = rename
           in [ let sut = "Applicatives & Lax Monoidal Functors： Bridging Computational and Category Theoretic Perspectives-0002.jpg"
                    wot = "applicatives-lax-monoidal-functors-bridging-computational-and-category-theoretic-perspectives"
                    got = f sut
                 in testCase sut $ wot @=? got
              ]

main :: IO ()
main = defaultMain tests
