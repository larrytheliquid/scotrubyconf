!SLIDE

Dependent Types
===============
A Look At The Other Side
------------------------

<div style="display: none">

an advanced form of static typing

will be using agda, but conceptually equivalent to other dependently
typed languages

many other arguments have been given in support of functional
languages such as easier parallelism, benefits of laziness, & benefits
of modularity

this will instead present an argument to a more fundamental problem
... scaling application complexity wrt testing

huge topic, will present a high-level version with an
emphasis on testing

!SLIDE
# Huh? #

<div style="display: none">

types at a rubyconf, what gives?

!SLIDE
# Trivial type guarantees #
  
    even : ℕ → Bool
    _*_ : ℕ → ℕ → ℕ
    isGoodDay : Day → Bool

<div style="display: none">

familiar type systems only protect against limited classes of
errors... arguably too limited to be useful
need to test logic anyway which catches these problems, so dynamic
languages like ruby are just as fine of an option

this presentation is NOT about trivial type guarantees
... but they will make their appearance at the beginning and with
certain other constraints can be very valuable on their own

!SLIDE bullets
# Ruby culture of testing #

* unit tests
* integration tests
* library tests
* framework tests
* end-user application tests

<div style="display: none">

TDD, BDD, tons of test libraries, cucumber, etc
fair to say that rubyists care about testing

with so much thought, time & energy spent on testing, it is worth
exploring languages which make it easier & possible to express more
meaningful guarantees

so... rubyists care about writing correct software

!SLIDE subsection

   Why
=========

<div style="display: none">

i arrived to this after a lifelong frustration of not being able to
write trustworthy large software applications that i could not
pinpoint the cause of exactly

it takes a lot of willpower to admit that the way you've been thinking
all your life has been wrong, and there is a better way, and that is
how i feel now about dynamically typed languages (as well as
trivial statical typing)

i think that this type theory is industry-changing, not some
interesting but ultimately irrelevant topic... i now see
most other languages & code written in them as legacy

...if you're watching this and have an instinctive negative
defensive mental reaction... i completely understand where you're
coming from... i invite you instead to notice this irrational behavior
& ignore it in favor of an open mind

!SLIDE bullets
# General problems at scale #

* need less runtime crashes
* need less bugs
* need trust in a deployed application

<div style="display: none">

developing understandable & trustworthy large applications right now sucks

need to not stay up at night worrying if some remote part of the big
system we just modified was affected by a big change we just made

need to not reach a maintenance dead end on large projects!
(typical story of productive feature releases early that comes to a
grinding maintenance halt later where a new feature introduction
requires a lot of time assuring that nothing else was affected

solution, as we've found, lies in testing... but there are still many
open problems that need to be solved

!SLIDE
# What happens at scale #

<div style="display: none">

when you try to test monolithic code, you get a combinatorial
explosion of test scenarios that becomes impractical to write
... then you break software up into encapsulated & loosely coupled
chunks

... this works, making something possible to fit all in your head and
feasible/easy to test, as evident by small single-purpose web services
(e.g. and/or middleware mounted rack/sinatra apps), specific
gems/libraries, etc

... but now you have the problem of testing/ensuring that the whole
works together correctly & uses each chunk according to its
(parameter) expectations

... in fact the combinatoric part of the problem may have grown as the
libraries are more general than your specific monolithic software

separately, we also have the problem of debugging runtime errors,
which become easier to introduce in large applications

!SLIDE smbullets
# Specific problems at scale #

* testing all possible inputs to prevent runtime errors
* testing & comprehending a large growing suite
* testing integration of highly cohesive & loosely coupled services
* relying on trust that a library works for our use case
* knowing where runtime errors could have occurred

<div style="display: none">

there is a solution to all of these with dependent types

trust that a lib works:
... duplicating tests that a library may have covered "just to be sure" in AR, etc)
... or just trust the library

!SLIDE bullets
# Specific solutions at scale #

* coverage checking
* implicit tests
* lemmas
* universal quantification
* purity + monads

!SLIDE subsection

Coverage checking
=================

!SLIDE
    data Day : Set where
      Monday Tuesday Wednesday : Day
      Thursday Friday : Day
      Saturday Sunday : Day
 
    isGoodDay : Day → Bool
    isGoodDay Friday   = true
    isGoodDay Saturday = true
    isGoodDay Sunday   = true
    isGoodDay _        = false

    isWeekDay : Day → Bool
    isWeekDay day = not (isGoodDay day)

<div style="display: none">

in ruby this wouldn't work because you would need to treat each
argument as any kind of object with any variation of defined methods

with specific datatypes + coverage checking you can are guaranteed
to never get a runtime error for the application of any arguments
related to being in the function's domain
... a world without "called X on nil class" errors!!

you may think that this may cause a lot of work for certain
types... like imagine needing to define addition of every single number!

!SLIDE
    _+_ : ℕ → ℕ → ℕ
    zero + n  = n
    suc m + n = suc (m + n)

    _*_ : ℕ → ℕ → ℕ
    zero * n  = zero
    suc m * n = n + (m * n)

<div style="display: none">

an emphasis on inductive
("recursive") definitions is placed that limit what you must write
out to the base & recursive cases

!SLIDE subsection

Implicit tests
==============

!SLIDE
    data GoodDay : Set where
      Friday Saturday Sunday : GoodDay
 
    isBestDay : GoodDay → Bool
    isBestDay Saturday = true
    isBestDay _        = false

    toDay : GoodDay → Day
    toDay Friday   = Friday
    toDay Saturday = Saturday
    toDay Sunday   = Sunday

<div style="display: none">

when writing the isBestDay function you only really want it to be
defined on any possible contenders for the title... GoodDays

you can also make new types with less constructors that are more
specific to the particular problem being solved... functions on those
are verified to be coverage complete
... then you can use a conversion function to a values in a "bigger"
type to interface with another library that uses the bigger type

notice that this specialized type is essentially an implicit test for
all functions using it... all those functions will only work for GoodDays

notice that constructors across multiple types can have same names, and can be
differentiated by the type signature they are in

!SLIDE
    fromDay : Day → GoodDay
    fromDay Friday   = Friday
    fromDay Saturday = Saturday
    fromDay Sunday   = Sunday
    fromDay _        = Friday

<div style="display: none">

of course we may also need to import more general data into our
specific types...
lame defaults!!!!!!!!!

this is a problem you face when enforcing coverage in most
languages... both undesirable obvious solutions are a runtime error
(which we are trying to avoid), or picking a default, which leads to
logic errors

... to solve this we will see our first use of dependent types

!SLIDE subsection

Dependent types
===============

!SLIDE
    record ⊤ : Set where
    
    data ⊥ : Set where

    ↑ : Bool → Set
    ↑ true  = ⊤
    ↑ false = ⊥

<div style="display: none">

notice that this is a function just like everything else, it just
happens to return a Set (type) instead of a value

... there is no special keyword indicating that this is a function on types
this is introduces a very important notion in dependent types, namely
that the wall separating the world of types & the world of values has
been torn down

!SLIDE
    fromDay : (day : Day) → 
              {precondition : ↑ (isGoodDay day)} → 
              GoodDay
    fromDay Friday   = Friday
    fromDay Saturday = Saturday
    fromDay Sunday   = Sunday
    fromDay _        = Friday

    compileError : GoodDay
    compileError = fromDay Tuesday

<div style="display: none">

you can see here why these are called "dependent" types, any type can
be given a label for the value it can represent, which can be reused
or "depended upon" in later parts of the type signature, from left to right

notice that our function call happens in the type signature
precondition not used here, just for readability

implicit arguments do not need to be explicitly passed when calling
the function

here we get a compile time error, not a run time exception!!!

!SLIDE
    fromDay : (day : Day) → 
              {_ : ↑ (isGoodDay day)} → 
              GoodDay
    fromDay Friday   = Friday
    fromDay Saturday = Saturday
    fromDay Sunday   = Sunday
    fromDay Monday    {()}
    fromDay Tuesday   {()}
    fromDay Wednesday {()}
    fromDay Thursday  {()}

<div style="display: none">

rather than defining a default answer that can never get used, here we
pattern match on the fact that ⊥ has no constructors (this () is
special syntax meaning this type is not inhabited)

the {} can be used to pattern match on implicit arguments instead of
omitting them like usual

!SLIDE
     _div_ : ℕ → (n : ℕ) → 
            {_ : ↑ (nonZero n)} → ℕ

    lookup : {A : Set}(n : ℕ)(xs : List A)
             {_ : ↑ (n < length xs)} → A

    isBestDay : (d : Day) → 
                {_ : ↑ (isGoodDay d) → Bool

<div style="display: none">

... this is a really big deal, because we can encode arbitrary
preconditions to restrict our function domain... no more divide by
zero errors!!!... no more index out of bounds errors!

note that we just leave the label for "precondition" blank to show our
intent of not using it

and finally note that we could also avoid creating a separate GoodDay
type and use preconditions instead if we wanted to

!SLIDE subsection

More implicit tests
=======================

<div style="display: none">

take a moment to realize that i said this presentation is on testing
but haven't shown an explicit tests yet (assertions, unit tests, etc)

a lot of value can be gained in an application by implicit assurances
through coverage checking and well-crafted and/or used specific types

we are used to this concept in the form of creating and using
abstractions (at low level code layer, or high level library/framework
layer)
... using types for these "abstractions" gives you the same benefits
but with real compile-time assurance

so far we've seen implicit tests via basic custom types, and implicit
tests via preconditions in function signatures... now we'll move on to
implicit tests via advanced custom types

!SLIDE
    data List (A : Set) : Set where
      []  : List A
      _∷_ : (x : A) (xs : List A) → List A

    bool-list : List Bool
    bool-list = false ∷ true ∷ false ∷ []

<div style="display: none">

simple polymorphic cons-based or "linked" list

!SLIDE
    data Vec (A : Set) : ℕ → Set where
      []  : Vec A zero
      _∷_ : {n : ℕ} (x : A) (xs : Vec A n) →
            Vec A (suc n)

    bool-vec : Vec Bool 3
    bool-vec = false ∷ true ∷ false ∷ []

<div style="display: none">

this is called an "indexed" type
the length of the vector/list is carried along in the type

note how the type signature changed to include the length 3
restriction, but the value stayed the same... we can get this extra
"implicit" test of the length 3 restriction "for free"!

!SLIDE
    _++_ : {A : Set} {n m : ℕ} → 
           Vec A n → Vec A m → 
           Vec A (n + m)
    [] ++ ys = ys
    x ∷ xs ++ ys = x ∷ (xs ++ ys)

<div style="display: none">

here we can see just by the type signature that the resulting vector
is length of the arguments added together... the type is giving us
extra information

again notice the "dependencies" in the type

this kind of encoding of data into types can let us make functions
like this whose type signature gives us additional safety
characteristics that you would not get in typical static typing

also note that the addition occurring in the type signature can be any
arbitrary function!

!SLIDE
    head : {A : Set} →
           List A → Maybe A
    head [] = nothing
    head (x ∷ _) = just x

    tail : {A : Set} → 
           List A → List A
    tail [] = []
    tail (_ ∷ xs) = xs

<div style="display: none">

really we want the head and tail of an empty list to be undefined, but
we also don't want runtime errors

the first example shows how we might handle the result in ruby with
nil, but then this leaks out into other functions that now have to
deal with a nil case everywhere that we really don't want ever to
happen

the second example uses a default value, which can lead to logic errors

!SLIDE
    head : {A : Set} {n : ℕ} →
           Vec A (1 + n) → A
    head (x ∷ _) = x

    tail : {A : Set} {n : ℕ} → 
           Vec A (1 + n) → Vec A n
    tail (_ ∷ xs) = xs

<div style="display: none">

here we use vectors to realize our intended domain restriction

no matter what the implicit n is, we add 1 so the argument can never
be of length zero (empty vector)

our tail type also gives more information, that the returned vector
will be of length exactly one less than the argument

note that we could have also used implicit isEmpty preconditions in
the list versions... good to have choices

!SLIDE
    data SortedList-ℕ : ℕ → Set where
      [] : SortedList-ℕ zero
      _∷_ : {n : ℕ} →
            (x : ℕ) →
            SortedList-ℕ n →
            {_ : ↑ (n ≤ x)} →
            SortedList-ℕ x

<div style="display: none">

values are correct by construction

this has incredible value... you never have to think about the
possibility that an expected sorted list is not actually sorted when
researching the cause of a bug!!!

!SLIDE
    sortedList-ℕ : SortedList-ℕ 8
    sortedList-ℕ = 8 ∷ 7 ∷ 2 ∷ []
    
    insert : {n : ℕ}(x : ℕ) →
             SortedList-ℕ n →
             SortedList-ℕ (x ⊔ n)

<div style="display: none">

if we break the sorted list semantics, we get a compilation error

here a large part of the semantics of the insert function is captured by its
type (without looking at the implementation)!!!

... the epitome of types as documentation that can't go out of date
(similar to how more familiar explicit tests act as documentation that
can't go out of date)

can also make types for things like balanced binary trees, etc
... or imagine an AuthorizedUser to protect certain functions from
only being accessed by those users

!SLIDE subsection

   Lemmas
============

<div style="display: none">

going to move into some more familiar explicit testing now

!SLIDE bullets
# Ruby test assertions #

* comments of expected results
* boolean comparison & returned boolean
* boolean comparison & exception raised

<div style="display: none">

dynamic!! (at run time)
the indicator we are left with of our "proven" fact is a boolean or
a string, neither of which have a semantic, language-level, tie
back to the assertion... "once you prove it, you lose it"
... any meaning we tie to these assertions in things like testing
frameworks are purely by convention

normal boolean tests are transformer functions that return a
bool... what that bool means is immediately lost to language
semantics, and we must rely on the convention that the bool
represented some previous check, prone to error

!SLIDE
# Curry-Howard isomorphism #

    dayIsInhabited : Day
    dayIsInhabited = Thursday

<div style="display: none">

here that a Day exists is our proposition & Thursday is a proof of that

in most type systems, making an analogy like doesn't gain you much
... but with dependent types you can represent practically any
arbitrary proposition

we just saw a useful example: SortedList-ℕ
... here the constructor value forces the implicit precondition to
supply a proof of top (inhabited) or bottom (not inhabited)

!SLIDE
# Propositional equality #

     data _≡_ {A : Set} (x : A) : A → Set where
       refl : x ≡ x
    -- bogus : {y : A} → x ≡ y

<div style="display: none">

we can make a custom datatype to represent unit test assertions... all
within the language 

in the same way that we could just pick a number to constrain a vector
length to, we can pick what the function returns (evaluated to) as the
index in order to have a valid constructor for it (refl)

note that we can pick any two arbitrary values (of the same type) to
have a validly typed proposition

the reuse of the variable x in the dependency expressed in refl
happens to enforce the equality between the 2 terms in the proposition
... remember back to the Vec [] constructor using zero as its index
for an arbitrary value in ℕ... here we reuse x "arbitrarily"

!SLIDE
# Agda test assertions #

    fridayIsGoodDay : isGoodDay Friday ≡ true
    fridayIsGoodDay = refl

    typeCheckingError : isGoodDay Wednesday ≡ true
    typeCheckingError = refl
    -- /home/larrytheliquid/src/scotrubyconf/Tester.agda:27,21-25
    -- false != true of type Bool
    -- when checking that the expression refl has type false ≡ true

<div style="display: none">

static!! (at compile time)
assertions happens at the type level

these can be arbitrary return values, not just booleans

this proof can be done automatically "by interpretation" when you
mention refl, as isGoodDay is called with specific & complete args

refl acts as a first-class proof in the language of our assertion; we
can store it in a variable, pass it around to other functions as
arguments, etc

once you have a type-checked refl you have unified those 2 values with
respect to the compiler... these can be reused in other proofs as
"lemmas"... this is literal reuse within the semantics of the
language, not arbitrary reuse according to conventions

if you are serious about testing, it's hard to go back to any language
that can't semantically encode tests after dependent
types... especially so elegantly in 2 lines of code... it is beautiful

i've been working on an agda project for 2 months that i haven't
"run" once, just compiled... but i'm sure it works as it's fully
tested!
... note how the lines between run time and compile time blur with
the ability dependent types give you to interchange where you'd
typical use the two... this is a major reason why you should consider
using this type theory as someone used to dynamic typing... you get
all the advantages of static typing while being able to execute
arbitrary "dynamic value code" in unrestricted places... e.g. perform
function calls in types during compile time in order to achieve unit
testing
... this even makes things like a repl much less necessary, as TDD'ers
have experienced with using testing frameworks & tests to
prototype/design behavior/etc

!SLIDE bullets
# Intuistionistic logic #

* *Classical logic:* every statement must inherently be true or false

* *Intuistionistic logic:* a statement is only "true" if you have a
  proof for it

<div style="display: none">

the concept of the proof is a part of the semantics
as we have seen, the intuistionistic approach has more value in a
programming language

!SLIDE subsection

Universal quantification
========================

!SLIDE
    goodDaysAreGood : (good : GoodDay) →
                      isGoodDay (toDay good) ≡ true
    goodDaysAreGood Friday   = refl
    goodDaysAreGood Saturday = refl
    goodDaysAreGood Sunday   = refl

<div style="display: none">

notice that a parameterized dependent proposition can act as universal
quantification we know from logic!!!

thanks to coverage checking, doing this is guaranteed to be true for
all GoodDays

!SLIDE
    goodDaysAreNotWeekdays : (good : GoodDay) →
      isWeekDay (toDay good) ≡ false
    goodDaysAreNotWeekdays good rewrite 
      goodDaysAreGood good = refl

<div style="display: none">

here is a really important bit... while trying to prove our more
complex proposition we can reuse our already-proven smaller
universally quantified proposition... which is really just a function
that can be called with a GoodDay just like any other
function... except it returns a proof value (refl) for that specific GoodDay
... proofs are inherently compositional!!!
... we use our previous proof as a lemma (helper proof) in this more
complex proof
.... now comes a really important realization: libraries can come with
lemmas that you instantiate with values from your specific problem domain
... so library/framework users can be more productive thanks to the
work of the library/framework authors... true composition &
modularity, which we talk about all the time in production code, can
finally be had in the world of tests!!!!!! *super big deal*
... can have a "public api" of lemmas
think about how much time is wasted by starting from scratch with
each project... a framework can come with universally quantified
lemmas that you instantiate with your particular application

unit tests can be reused literally in integration tests
... no more leaving it up to hope that the results of one confirm
results in the other
what is a unit test and what is an integration test is relative
... you can use your "integration tests" in one service as lemmas to
prove statements between several interacting services
... cures the problem of the explosion of tiny services that must be
somehow confirmed to work together

!SLIDE
# Existential quantification
    data Σ (A : Set) (B : A → Set) : Set where
      _,_ : (x : A) (y : B x) → Σ A B

    ∃ : ∀ {A : Set} → (A → Set) → Set
    ∃ = Σ _

    aGoodBestDayExists : ∃ λ good → 
      isBestDay good ≡ true
    aGoodBestDayExists = Saturday , refl

<div style="display: none">

the really important thing to note here is that we no longer merely
return a day satisfying some constraint, or a proof of that
constraint, but both together

doing this makes future proofs that use this lemma shorter as they
don't have to get both of these pieces of information separately and
proof that they are related

!SLIDE
    inverses : (day : Day) →
               (p : isGoodDay day ≡ true) →
               FromDay day p 
                 (λ good → toDay good ≡ day)
            -- toDay (fromDay day) ≡ day
    inverses Friday   _ = refl
    inverses Saturday _ = refl
    inverses Sunday   _ = refl
    inverses Monday    ()
    inverses Tuesday   ()
    inverses Wednesday ()
    inverses Thursday  ()

<div style="display: none">

realize that this inverse property holds over every good day

!SLIDE
    FromDay : (day : Day) → 
              isGoodDay day ≡ true → 
              (GoodDay → Set) → 
              Set
    FromDay Friday   _ f = f (fromDay Friday)
    FromDay Saturday _ f = f (fromDay Saturday)
    FromDay Sunday   _ f = f (fromDay Sunday)
    FromDay Monday    () _
    FromDay Tuesday   () _
    FromDay Wednesday () _ 
    FromDay Thursday  () _

!SLIDE
    ∃₂ : {A : Set} {B : A → Set}
         (C : (x : A) → B x → Set) → Set
    ∃₂ C = ∃ λ a → ∃ λ b → C a b

    aDayBestDayExists : ∃₂ λ day p → 
      FromDay day p
        (λ good → isBestDay good ≡ true)
     -- isBestDay (fromDay day) ≡ true
    aDayBestDayExists = Saturday , refl , refl

!SLIDE subsection

Purity + monads
===============

!SLIDE
# Ruby VS purely functional

    # Ruby
    Kernel#puts
    String#reverse!

    -- Agda
    putStrLn : String → IO ⊤
    unsafeReverse : IORef String → IO (IORef String)

<div style="display: none">

Ruby unrestricted mutation & metaprogramming... useful to write but
hard to reason about later

haskell-like purity... side-effects semantically restricted in type
signature via monads... this is not unique to dependent types,
e.g. haskell does the same

ruby uses ! convention to mark dangerous operations, and to a lesser
extent side effects

haskell instead uses language semantics to guarantee where side
effects can only possibly happen

can get a list of spots where a side-effect bug could have occurred
back... without this distinction testing/debugging is harder!

imagine how confusing a ? predicate method that mutates could
be... conventions are not enough

monads for isolation of side effecting code from pure code is really
another form of implicit testing

!SLIDE
    data Image_∋_ {A B : Set}(f : A → B) : 
      B → Set where
      im : {x : A} → Image f ∋ f x

    inv : {A B : Set}(f : A → B)(y : B) → 
          Image f ∋ y → A
    inv f .(f x) (im {x}) = x

                     -- Day           GoodDay
    testInv : inv toDay Saturday im ≡ Saturday
    testInv = refl

<div style="display: none">

example advantage of purity
... generic inverse not by logging data & replaying or anything, just
via the type system!!!
... purity & dependent types let you go back in time! =p

!SLIDE
    fromDay : (day : Day) → {_ : T (isGoodDay day)} → 
              GoodDay
    fromDay Friday = inv toDay Friday im
    fromDay Saturday = inv toDay Saturday im
    fromDay Sunday = inv toDay Sunday im
    fromDay Monday {()}
    fromDay Tuesday {()}
    fromDay Wednesday {()}
    fromDay Thursday {()}

<div style="display: none">

grand finale... we can now go back and redefine fromDay
... except this time we guarantee our inverse property by definition
... no chance of screwing up, and will adapt to future code changes properly!!!

... and all our previous proofs (including our "inverses" still
check!!! (refactoring)

!SLIDE
# Fin #

!SLIDE
    data GoodDay : Day → Set where
      Friday : GoodDay Friday
      Saturday : GoodDay Saturday
      Sunday : GoodDay Sunday

    toDay : {day : Day} → GoodDay day → Day
    toDay {day} _ = day

<div style="display: none">

an alternative representation of GoodDay that directly expresses the
relationship between the two types

we get toDay "for free" & don't really need it

!SLIDE
    goodDaysAreGood : {day : Day} → 
      GoodDay day → isGoodDay day ≡ true
    goodDaysAreGood Friday = refl
    goodDaysAreGood Saturday = refl
    goodDaysAreGood Sunday = refl

    goodDaysAreNotWeekdays : {day : Day} → 
      GoodDay day → WeekDay day ≡ false
    goodDaysAreNotWeekdays good 
      rewrite goodDaysAreGood good = refl
