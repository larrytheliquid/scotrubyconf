module Tester where
open import Data.Nat
open import Data.Bool
open import Relation.Binary.PropositionalEquality

-- maybe use something more simple like adding 2

-- suc suc
even : ℕ → Bool
even zero = true
even (suc zero) = false
even (suc (suc n)) = even n

zeroIsEven : even 0 ≡ true
zeroIsEven = refl

oneIsNotEven : even 1 ≡ false
oneIsNotEven = refl

sevenIsNotEven : even 7 ≡ false
sevenIsNotEven = refl

fortyTwoIsEven : even 42 ≡ true
fortyTwoIsEven = refl
-- Checked

-- typeCheckingError : even 1337 ≡ true
-- typeCheckingError = refl
-- /home/larrytheliquid/src/scotrubyconf/Tester.agda:27,21-25
-- false != true of type Bool
-- when checking that the expression refl has type false ≡ true

