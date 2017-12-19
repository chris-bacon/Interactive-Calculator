module Lib where

import Control.Monad
import Data.Char
import Text.Regex.Posix
import Data.List.Split
import System.IO
import Types

-- Parser
eval :: Equation -> Int
eval (Mul x y) = eval x * eval y
eval (Div x y) = eval x `safeDiv` eval y
eval (Add x y) = eval x + eval y
eval (Sub x y) = eval x - eval y
eval (Lit x) = x

-- Lexical Analysis
lexicalAnalyzer :: [String] -> Buffer -> Buffer -> Equation
lexicalAnalyzer [] cbuffer nbuffer = Lit $ toInt nbuffer
lexicalAnalyzer (x:xs) cbuffer nbuffer
    -- Descend tree
    | isInt nbuffer && cbuffer == "+" = Add (Lit $ toInt nbuffer) (lexicalAnalyzer (x:xs) [] [])
    | isInt nbuffer && cbuffer == "-" = Sub (Lit $ toInt nbuffer) (lexicalAnalyzer (x:xs) [] [])
    | isInt nbuffer && cbuffer == "/" = Div (Lit $ toInt nbuffer) (lexicalAnalyzer (x:xs) [] [])
    | isInt nbuffer && cbuffer == "*" = Mul (Lit $ toInt nbuffer) (lexicalAnalyzer (x:xs) [] [])
    -- Operators
    | x == "+" = lexicalAnalyzer xs "+" nbuffer
    | x == "-" = lexicalAnalyzer xs "-" nbuffer
    | x == "/" = lexicalAnalyzer xs "/" nbuffer
    | x == "*" = lexicalAnalyzer xs "*" nbuffer
    -- Values
    | isInt x && isInt nbuffer = lexicalAnalyzer xs cbuffer nbuffer -- End of number
    | isInt x = lexicalAnalyzer xs cbuffer (nbuffer ++ x)
    -- Misc
    | x == "" = lexicalAnalyzer xs cbuffer nbuffer -- Ignore
    | x == " " = lexicalAnalyzer xs cbuffer nbuffer -- Ignore
    | otherwise = error("Syntax error: " ++ x)

toInt :: String -> Int
toInt x = read x :: Int

isInt :: String -> Bool
isInt x = x =~ "([0-9])+" :: Bool

safeDiv :: (Integral a, Eq a) => a -> a -> a
safeDiv _ 0 = 0
safeDiv n m = n `div` m
