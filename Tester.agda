module Tester where
open import Data.Nat hiding (_≤_)
open import Data.Bool
open import Data.Product
open import Relation.Binary.PropositionalEquality
open import Data.Unit hiding (_≤_)
open import Data.Empty

-- data _≡_ {A : Set} (x : A) : A → Set where
--   refl : x ≡ x
--   bogus : {y : A} → x ≡ y

-- eh : true ≡ false
-- eh = bogus


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

data Day : Set where
  Monday Tuesday Wednesday : Day
  Thursday Friday : Day
  Saturday Sunday : Day
 
isGoodDay : Day → Bool
isGoodDay Friday = true
isGoodDay Saturday = true
isGoodDay Sunday = true
isGoodDay _ = false

isWeekDay : Day → Bool
isWeekDay day = not (isGoodDay day)

data GoodDay : Set where
  Friday Saturday Sunday : GoodDay

isBestDay : GoodDay → Bool
isBestDay Saturday = true
isBestDay _ = false

toDay : GoodDay → Day
toDay Friday = Friday
toDay Saturday = Saturday
toDay Sunday = Sunday

goodDaysAreGood : (good : GoodDay) →
                  isGoodDay (toDay good) ≡ true
goodDaysAreGood Friday = refl
goodDaysAreGood Saturday = refl
goodDaysAreGood Sunday = refl

goodDaysAreNotWeekdays : (good : GoodDay) →
                         isWeekDay (toDay good) ≡ false
goodDaysAreNotWeekdays good rewrite goodDaysAreGood good = refl

fromDay : (day : Day) → {_ : T (isGoodDay day)} → GoodDay
fromDay Friday = Friday
fromDay Saturday = Saturday
fromDay Sunday = Sunday
fromDay Monday {()}
fromDay Tuesday {()}
fromDay Wednesday {()}
fromDay Thursday {()}

FromDay : (day : Day) → isGoodDay day ≡ true → (GoodDay → Set) → Set
FromDay Friday _ f = f (fromDay Friday)
FromDay Saturday _ f = f (fromDay Saturday)
FromDay Sunday _ f = f (fromDay Sunday)
FromDay Monday () _
FromDay Tuesday () _
FromDay Wednesday () _ 
FromDay Thursday () _

inverses : (day : Day) →
           (p : isGoodDay day ≡ true) →
           FromDay day p (λ good → toDay good ≡ day)
        -- toDay (fromDay day) ≡ day
inverses Friday _ = refl
inverses Saturday _ = refl
inverses Sunday _ = refl
inverses Monday ()
inverses Tuesday ()
inverses Wednesday ()
inverses Thursday ()

aGoodBestDayExists : ∃ λ good → isBestDay good ≡ true
aGoodBestDayExists = Saturday , refl

aDayBestDayExists : ∃₂ λ day p → FromDay day p (λ good → isBestDay good ≡ true)
                              -- isBestDay (fromDay day) ≡ true
aDayBestDayExists = Saturday , refl , refl


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

