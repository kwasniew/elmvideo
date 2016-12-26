# 'A Complete Intro to React' ported to elm

A port of https://github.com/btholt/complete-intro-to-react to Elm

```
elm-live src/Main.elm --dir=. --open --pushstate --output=public/elm.js --debug
elm test
```

# Lessons learned

Compared to React:  
:simple_smile: less library specific vocabulary/constructs, encourages simple language features  
:simple_smile: one language instead of JS with JSX inside with more JS inside  
:simple_smile: new syntax is easy to learn (probably it takes less time than to learn new features from ES6)  
:simple_smile: pure stateless functions instead of classes/components with lifecycle hooks  
:simple_smile: function variables instead of props  
:simple_smile: thisless programming enforced, not just encouraged  
:simple_smile: elm-format on save removes unnecessary decisions about formatting  
:simple_smile: once it compiles it usually works as expected  
:sob: slower to hack something quickly  
:simple_smile: forces you to handle all corner cases, so time to production-ready is shorter  
:simple_smile: modules just work without any extra tooling  
:simple_smile: navigation more verbose then routing, but less magic overall  
:simple_smile: no local state in components leads to better reproducibility (time travel debugger built into Elm)  
:simple_smile: side effects can happen only in init and update functions instead of being spread over your codebase  
:simple_smile: specific architecture is enforced, not just encouraged  
:simple_smile: impossible to forget about unhandled messages due to compiler catching errors  
:sob: no server side rendering yet  
:sob: no code splitting yet  
:sob: duplication of test packages  


Overall impression:  
Very positive. Once Elm has some aspect of building web apps covered it's usually done in a very elegant way
and it encourages you to do the right thing.
It looks like you can achieve Elm like experience with some good habits + React/Redux/ImmutableJS/TypeScript + some tooling
but Elm gives you everything in a package that just works and forces you to do the right thing. Really looking forward to server side rendering
as it's my only concern right now.
