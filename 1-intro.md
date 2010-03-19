!SLIDE
Dependent Types
===============
A Look At The Other Side
------------------------

<div style="display: none">

an advanced form of static typing

will be using agda, but conceptually equivalent to other dependently
typed languages

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
    isWeekend : Day → Bool

<div style="display: none">

familiar type systems only protect against limited classes of
errors... arguably too limited to be useful
need to test logic anyway which catches these problems, so dynamic
languages like ruby are just as fine of an option

of course, the ability to create custom types & types nested in other
types makes type signature complexity add up and be a useful
assurance, but i digress

this presentation is NOT about trivial type guarantees

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
# Why #

<div style="display: none">

i arrived to this after a lifelong frustration of not being able to
write trustworthy large software applications that i could not
pinpoint the cause of exactly

it takes a lot of willpower to admit that the way you've been thinking
all your life has been wrong, and there is a better way, and that is
how i feel now about dynamically typed languages (as well as
trivial statical typing)

i think that this type theory is industry-changing, not some
interesting but ultimately irrelevant topic... from my perspective
most other languages & code written in them are legacy

...if you're watching this and have an instinctive negative
defensive mental reaction... i completely understand where you're
coming from... i invite you instead to notice this irrational behavior
& instead ignore it in favor of an open mind

scaling application complexity
developing understandable & trustworthy large applications right now sucks

many other arguments have been given in support of functional
languages such as easier parallelism, benefits of laziness, & benefits
of modularity

this will instead present an argument of easier and better testing

... now go into the current open problems & solutions for them

!SLIDE
# Ruby VS purely functional

    # Ruby
    Kernel#puts
    String#reverse!

    -- Agda
    putStr : String → IO ⊤
    reverse! : String → Monad String

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

TODO: May want to mention simple non-dependent curry-howard here?

!SLIDE bullets
# Ruby test assertions

* comments of expected results
* boolean comparison & returned boolean
* boolean comparison & exception raised

// dynamic!! (at run time)
// the indicator we are left with of our "proven" fact is a boolean or
// a string, neither of which have a semantic, language-level, tie
// back to the assertion... "once you prove it, you lose it"

!SLIDE
# Agda test assertions

    fortyTwoIsEven : even 42 ≡ true
    fortyTwoIsEven = refl
    -- Checked

    typeCheckingError : even 1337 ≡ true
    typeCheckingError = refl
    -- /home/larrytheliquid/src/scotrubyconf/Tester.agda:27,21-25
    -- false != true of type Bool
    -- when checking that the expression refl has type false ≡ true

// normal boolean tests are transformer functions that return a
// bool... what that bool means is immediately lost to language
// semantics, and we must rely on the convention that the bool
// represented some previous check, prone to error

// static!! (at compile time)
// assertions happens at the type level

// this proof can be done automatically "by interpretation" when you
// mention refl, as even is called with specific & complete args

// refl acts as a first-class proof in the language of our assertion; we
// can store it in a variable, pass it around to other functions as
// arguments, etc

// if you are serious about testing, it's hard to go back to any language
// that can't semantically encode tests after dependent types

// i've been working on an agda project for 2 months that i haven't
// "run" once, just compiled... but i'm sure it works as it's fully tested!

!SLIDE
# Intuistionistic logic

*Classical logic:* every statement must inherently be true or false

*Intuistionistic logic:* a statement is only "true" if you have a
 proof for it

// the concept of the proof is a part of the semantics
// as we have seen, the intuistionistic approach has more value in a
// programming language

!SLIDE
# Propositional equality datatype

    data _≡_ {A : Set} (x : A) : A → Set where
      refl : x ≡ x

// will come back to this later, but only 2 lines of code for
// statically checked assertions!
// Also unifies both values

!SLIDE subsection
# Language basics

!SLIDE
# Coverage checking
TODO

// may seem limiting, but not when an emphasis on inductive
// ("recursive") definitions is placed that limit what you must write
out to the base & recursive cases

!SLIDE
# Termination checking
TODO

!SLIDE
# Magic inverse
TODO

!SLIDE
# Universal quantification
TODO

!SLIDE
# Existential quantification
TODO

!SLIDE
# Compositional tests/proofs/lemmas

// proofs are inherently compositional!

// unit tests can be reused literally in integration tests
// ... no more leaving it up to hope that the results of one confirm
// results in the other

// what is a unit test and what is an integration test is relative... can
// be at all levels between app code, library code, framework code,
// between web services, etc!
// ... cures the problem of the explosion of tiny services that must be
// somehow confirmed to work together

!SLIDE
# Libraries: code + proofs!

// think about how much time is wasted by starting from scratch with
// each project... a framework can come with universally quantified
// lemmas that you instantiate with your particular application

