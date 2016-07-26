#lang racket/base
(module reader racket/base
  (provide read read-syntax get-info)
  (require (submod "case-insensitive.rkt" reader)))
