{-# LANGUAGE FlexibleContexts #-}

module Main where

import Control.Monad
import Data.Char
import Text.Regex.Posix
import Data.List.Split
import System.IO

-- Parser

-- Let an equation be either:
--  (1) a formula consisting of a value and/or another equation and an operator (i.e. 2 + 3)
--  (2) a single value (i.e. 2)
data Equation
    = Add Equation Equation
    | Sub Equation Equation
    | Mul Equation Equation
    | Div Equation Equation
    | Lit Int
    deriving (Show)

eval :: Equation -> Int
eval (Mul x y) = eval x * eval y
eval (Div x y) = eval x `div` eval y
eval (Add x y) = eval x + eval y
eval (Sub x y) = eval x - eval y
eval (Lit x) = x

-- Lexical Analysis

toInt :: [Char] -> Int
toInt x = read x :: Int

isInt :: String -> Bool
isInt x = x =~ "([0-9])+" :: Bool

lexicalAnalyzer :: [[Char]] -> [Char] -> [Char] -> Equation
lexicalAnalyzer [] cbuffer nbuffer = (Lit (toInt nbuffer))
lexicalAnalyzer (x:xs) cbuffer nbuffer
    -- Descend tree
    | (isInt nbuffer) && (cbuffer == "+") = Add (Lit (toInt nbuffer)) (lexicalAnalyzer (x:xs) [] [])
    | (isInt nbuffer) && (cbuffer == "-") = Sub (Lit (toInt nbuffer)) (lexicalAnalyzer (x:xs) [] [])
    | (isInt nbuffer) && (cbuffer == "/") = Div (Lit (toInt nbuffer)) (lexicalAnalyzer (x:xs) [] [])
    | (isInt nbuffer) && (cbuffer == "*") = Mul (Lit (toInt nbuffer)) (lexicalAnalyzer (x:xs) [] [])
    -- Operators
    | x == "+" = lexicalAnalyzer xs "+" nbuffer
    | x == "-" = lexicalAnalyzer xs "-" nbuffer
    | x == "/" = lexicalAnalyzer xs "/" nbuffer
    | x == "*" = lexicalAnalyzer xs "*" nbuffer
    -- Values
    | (isInt x) && (isInt nbuffer) = lexicalAnalyzer xs cbuffer nbuffer -- End of number
    | (isInt x) = lexicalAnalyzer xs cbuffer (nbuffer ++ x)
    -- Misc
    | x == "" = lexicalAnalyzer xs cbuffer nbuffer -- Ignore
    | x == " " = lexicalAnalyzer xs cbuffer nbuffer -- Ignore
    | otherwise = error("Syntax error: " ++ x)

main :: IO ()
main = forever $ do
    putStr "> "
    hFlush stdout -- This is needed because putStr buffers so user input occurs before putStr is displayed
    equation <- getLine
    let brokenEquation = splitOn "" equation
    print $ eval $ lexicalAnalyzer brokenEquation [] []
