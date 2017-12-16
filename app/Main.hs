{-# LANGUAGE FlexibleContexts #-}

module Main where

import Control.Monad
import Data.Char
import Text.Regex.Posix
import Data.List.Split
import System.IO
import Lib

main :: IO ()
main = forever $ do
    putStr "> "
    hFlush stdout -- This is needed because putStr buffers so user input occurs before putStr is displayed
    equation <- getLine
    let brokenEquation = splitOn "" equation
    print $ eval $ lexicalAnalyzer brokenEquation [] []
