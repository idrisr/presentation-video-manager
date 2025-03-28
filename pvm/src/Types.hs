{-# LANGUAGE OverloadedStrings #-}

module Types where

import Control.Monad
import Control.Monad.Trans.Class
import Control.Monad.Trans.Reader
import DFA
import Data.Aeson.Types
import Data.Foldable
import Data.List
import qualified Data.Yaml as Y
import System.Directory
import System.FilePath

newtype Album = Album {getAlbum :: FilePath}
    deriving (Show)

instance Y.FromJSON Album where
    parseJSON (Y.Object v) = Album <$> v .: "album"
    parseJSON invalid = prependFailure "parsing Coord failed, " (typeMismatch "Object" invalid)

newtype Slide = Slide {getSlide :: FilePath}
    deriving (Show)

mkAlbumFor :: Slide -> ReaderT Album IO ()
mkAlbumFor s =
    do
        a <- ask
        let aName = rename . getSlide $ s
            old = getAlbum a </> getSlide s
            new = getAlbum a </> aName </> getSlide s
         in do
                lift $ createDirectoryIfMissing True $ getAlbum a </> aName
                lift $ renameFile old new

orgAlbum :: ReaderT Album IO ()
orgAlbum = do
    a <- ask
    let f = getAlbum a
    fs <- lift $ listDirectory f
    gs <- lift $ filterM doesFileExist $ (f </>) <$> sort fs
    traverse_ (mkAlbumFor . Slide . takeFileName) gs
