module Types where

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

type Buffer = String 
