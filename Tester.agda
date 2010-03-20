module Tester where
open import Data.Nat hiding (_≤_)
open import Data.Bool
open import Relation.Binary.PropositionalEquality
open import Data.Unit hiding (_≤_)
open import Data.Empty

_≤_ : ℕ → ℕ → Bool
zero ≤ _ = true
suc _ ≤ zero = false
suc n ≤ suc m = n ≤ m

infixr 5 _∷_

data SortedList-ℕ : ℕ → Set where
  [] : SortedList-ℕ zero
  _∷_ : {n : ℕ} →
        (x : ℕ) →
        SortedList-ℕ n →
        {_ : T (n ≤ x)} →
        SortedList-ℕ x

sortedList-ℕ : SortedList-ℕ 8
sortedList-ℕ = 8 ∷ 7 ∷ 2 ∷ []

postulate insert : {n : ℕ}(x : ℕ)
                   → SortedList-ℕ n
                   → SortedList-ℕ (x ⊔ n)

-- data Day : Set where
--   Monday Tuesday Wednesday : Day
--   Thursday Friday : Day
--   Saturday Sunday : Day
 
-- isGoodDay : Day → Bool
-- isGoodDay Friday = true
-- isGoodDay Saturday = true
-- isGoodDay Sunday = true
-- isGoodDay _ = false 

-- data GoodDay : Set where
--   Friday Saturday Sunday : GoodDay

-- fromWeekday : (day : Day) → {_ : T (isGoodDay day)} → GoodDay
-- fromWeekday Friday = Friday
-- fromWeekday Saturday = Saturday
-- fromWeekday Sunday = Sunday
-- fromWeekday _ = Friday

-- compileError : GoodDay
-- compileError = fromWeekday Tuesday

-- fromWeekday : (day : Day) → {_ : T (isGoodDay day)} → GoodDay
-- fromWeekday Friday = Friday
-- fromWeekday Saturday = Saturday
-- fromWeekday Sunday = Sunday
-- fromWeekday Monday {()}
-- fromWeekday Tuesday {()}
-- fromWeekday Wednesday {()}
-- fromWeekday Thursday {()}


-- -- maybe use something more simple like adding 2

-- -- suc suc
-- even : ℕ → Bool
-- even zero = true
-- even (suc zero) = false
-- even (suc (suc n)) = even n

-- zeroIsEven : even 0 ≡ true
-- zeroIsEven = refl

-- oneIsNotEven : even 1 ≡ false
-- oneIsNotEven = refl

-- sevenIsNotEven : even 7 ≡ false
-- sevenIsNotEven = refl

-- fortyTwoIsEven : even 42 ≡ true
-- fortyTwoIsEven = refl
-- -- Checked

-- typeCheckingError : even 1337 ≡ true
-- typeCheckingError = refl
-- /home/larrytheliquid/src/scotrubyconf/Tester.agda:27,21-25
-- false != true of type Bool
-- when checking that the expression refl has type false ≡ true

