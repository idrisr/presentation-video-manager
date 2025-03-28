module Main (main) where

import Control.Monad.Trans.Reader
import qualified Data.Yaml as Y
import Options.Applicative
import System.Directory
import System.Environment
import Types

main :: IO ()
main = start >>= \a -> runReaderT orgAlbum a

-- can be MaybeT IO or ExceptT IO
getConfig :: IO Album
getConfig = getXdgDirectory XdgConfig "pvm/config.yaml" >>= Y.decodeFileThrow

-- IO     , for obvious reasons
-- Either , in case of config file reading failure, parsing failure
-- Reader , to pass in config
-- Writer , for logs

-- can be MaybeT IO or ExceptT IO
start :: IO Album
start = do
    a <- execParserPure defaultPrefs opts <$> getArgs
    case a of
        Success b -> pure b
        Failure _ -> getConfig
        CompletionInvoked _ -> start

album :: Parser Album
album =
    Album
        <$> strOption
            ( long "album"
                <> short 'a'
                <> metavar "</path/to/album>"
                <> help "directory for parent directory"
            )

opts :: ParserInfo Album
opts =
    info
        (album <**> helper)
        ( fullDesc
            <> progDesc "organize a directory of screenshots by name into folders"
            <> header "pvm - a program to organize an album of screenshots from videos"
        )
