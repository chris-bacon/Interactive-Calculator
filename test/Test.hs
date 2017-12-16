import Test.QuickCheck
import Test.Hspec
import Lib

main :: IO ()
main = do
    hspec $ 
        describe "Test" $ do
            describe "safe division function" $ do
                it "Safely handles division by zero" $ do
                    safeDiv 10 0 `shouldBe` 0
                it "Divides 30 by 10 correctly" $ do
                    safeDiv 30 10 `shouldBe` 3
                it "Divides 30 by 3 correctly" $ do
                    safeDiv 30 3 `shouldBe` 10

            describe "eval function" $ do
                it "Multiplies 5 by 5 correctly" $ do
                    eval (Mul (Lit 5) (Lit 5)) `shouldBe` 25
                it "Divides 30 by 3 correctly" $ do
                    eval (Div (Lit 30) (Lit 3)) `shouldBe` 10
                it "Adds 312 and 3 correctly" $ do
                    eval (Add (Lit 312) (Lit 3)) `shouldBe` 315
                it "Returns a literal number correctly" $ do
                    eval (Lit 7) `shouldBe` 7
