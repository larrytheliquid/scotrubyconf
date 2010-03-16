!SLIDE
# Dependent Types
## A Look At The Other

// will be using agda, but conceptually equivalent to other dependently
// typed languages

// huge topic, will present a high-level version with an
// emphasis on testing

// don't feel the need to understand exactly how everything works
// during the presentation, this is a quick overview that you can come
// back to

!SLIDE subsection
# Why

// many other arguments have been given in support of functional
// languages such as easier parallelism, benefits of laziness, & benefits
// of modularity

// this will instead present an argument of easier and better testing

// fair warning that although the language presented has impressive
// capabilities, it is still under active research & development, and
// does not have much currently in the way of useful libraries

!SLIDE bullets
# Ruby culture of testing

* unit tests
* integration tests
* library tests
* framework tests
* end-user application tests

// TDD, BDD, zillions of test libraries, cucumber, etc
// fair to say that rubyists care about testing

// with so much though, time & energy spent on testing, it is worth
// exploring languages which make it easier & possible to express more
// meaningful guarantees

!SLIDE
# Trivial type guarantees
  
    even : ℕ → Bool
    even zero = true
    even (suc zero) = false
    even (suc (suc n)) = even n

// familiar type systems only protect against limited classes of
// errors... arguably too limited to be useful

// of course, the ability to create custom types & types nested in other
// types makes type signature complexity add up and be a useful
// assurance, but i digress

// competing statically typed languages like ocaml & scala offer these
// kinds of guarantees which may very well be just checked along with
// tests that you need to write anyway

!SLIDE
# Ruby VS purely functional

    # Ruby
    Kernel#puts
    String#reverse!

    -- Agda
    putStr : String → IO ⊤
    reverse! : String → Monad String

// Ruby unrestricted mutation & metaprogramming... useful to write but
// hard to reason about later

// haskell-like purity... side-effects semantically restricted in type
// signature via monads... this is not unique to dependent types,
// e.g. haskell does the same

// ruby uses ! convention to mark dangerous operations, and to a lesser
// extent side effects

// haskell instead uses language semantics to guarantee where side
// effects can only possibly happen

// can get a list of spots where a side-effect bug could have occurred
// back... without this distinction testing/debugging is harder!

// imagine how confusing a ? predicate method that mutates could
// be... conventions are not enough

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

Classical logic says every statement must inherently be true or false

Intuistionistic logic says a statement must first be proven to be
considered "true"

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
// ("recursive") definitions is placed

!SLIDE
# Termination checking
TODO
