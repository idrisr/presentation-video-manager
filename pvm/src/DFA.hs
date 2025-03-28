module DFA (rename) where

import Control.Monad.Trans.State.Lazy
import Data.Char (isAscii, isLetter, toLower)
import System.FilePath

data S = Space | NoSpace | Start
    deriving (Show, Eq)

type Input = String
type Output = String

dfa :: Input -> State (S, Input) Output
dfa s = do
    (t, y) <- get
    case y of
        [] -> pure s
        (x : xs) -> do
            let (v, w) = trans t x
            put (v, xs)
            dfa $ s ++ w

-- transition function
trans :: S -> Char -> (S, String)
trans s c = case (s, isGoodCharacter c) of
    (Start, Just c2) -> (NoSpace, [c2])
    (Start, Nothing) -> (Start, mempty)
    (Space, Just c2) -> (NoSpace, ['-', c2])
    (Space, Nothing) -> (Space, mempty)
    (NoSpace, Just c2) -> (NoSpace, [c2])
    (NoSpace, Nothing) -> (Space, mempty)

rename :: FilePath -> FilePath
rename f = evalState (dfa mempty) (Start, takeBaseName f)

isGoodCharacter :: Char -> Maybe Char
isGoodCharacter c | isLetter c && isAscii c = Just . toLower $ c
isGoodCharacter _ = Nothing
