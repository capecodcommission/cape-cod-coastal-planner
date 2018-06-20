# 1. Use Elm as Frontend Language
Date: 6/18/2018

## Status
Accepted

## Context
Because this project is going to be delivered as a Beta project by the end of the year, it will be likely that its needs will grow as feedback from real users begins to filter in, as new ideas are conceived, new platforms are required, and as sources of funding are renewed. In order to accommodate these concerns, CHIP needs a reliable and fast UI/UX that can be easily maintained.

## Decision
Elm is a pure functional language for building reliable web apps with great performance and no runtime exceptions.

## Consequences
Some of Elm's key benefits include:
- It's a pure functional and immutable language, which bring with it a host of benefits like
    - referential transparency
    - reduced cognitive load in understanding data flow
    - easier to write unit tests
    - eliminates an entire class of bugs that are introduced with mutable/OOP paradigms
    - allows for better optimizations by compiler because it can safely make more assumptions
- Very strong type system allows for powerful, reliable modeling of business domains and UX workflows. It makes it easier to make impossible states actually impossible.
- Known for having a fantastic compiler that outputs remarkably useful error messages and provides for one of the best refactoring experiences available
- The Elm Architecture (TEA) keep state in a single place (the Model), restricts all modifications to being described in a single place (the Update), and gives the full power of the language to the creation of the UI in the View.
- Strong and safe interop with JavaScript through Ports and Flags: if you get a runtime exception, you can bet its in the JS side of things. Elm won't let you write unsafe code.
- Helps solve JS fatigue and dependency complexity. To get everything that is built into Elm in the world of just JS you would need something like the following: React + JSX, Redux, Redux-Saga, React-Redux, Immutable.js, Sanctuary or Rambda, TypeScript or Flow, ES6+ and Babel. With Elm you just need...Elm. 
- Because it's a language and not just a library, development of Elm itself is more deliberate and considered with major versions being released much more slowly than in the JS world, so you can focus on developing your app instead of always upgrading your dependencies. Thanks Elm's type system and compiler, when it _is_ time for upgrading, Elm's upgrade helper can take care of most if not all of the migration automatically.
- It's very, very fast, especially when you optimize with Html.Lazy or Html.Keyed, for instance.
- Enforced Semantic Versioning: Elm can detect all API changes automatically which is used to force the Elm package catalog to follow semver precicely. This means you can guarantee you aren't getting a hidden breaking change when upgrading a library to a minor version bump!

Some thigns developers will need to be aware of:
- Though it's being used in production by many companies now for several years, it has not yet reached 1.0 status. 


