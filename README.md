gnal-lang [![Build Status](https://travis-ci.org/AlexKnauth/gnal-lang.png?branch=master)](https://travis-ci.org/AlexKnauth/gnal-lang)
===
A racket `#lang` that allows relative module paths for reader languages

If `"my-lang.rkt"` contains a `reader` submodule with a reader
implementation, then you can use that as a `#lang` even when it's not
installed as a collection, by using the `#lang` line:
```racket
#lang gnal "my-lang.rkt"
```

If `"my-lang"` refers to a directory that contains a `/lang/reader.rkt`
file, then you can use that as a `#lang` as well, with:
```racket
#lang gnal "my-lang"
```
