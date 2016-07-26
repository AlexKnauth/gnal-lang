#lang racket/base

(provide (rename-out [-read read]
                     [-read-syntax read-syntax]
                     [-get-info get-info]))

(require (only-in syntax/module-reader make-meta-reader))

(define (read-spec in)
  (read in))

(define (reader-mod-paths spec)
  (cond [(symbol? spec)
         (and
          (module-path? spec)
          (vector-immutable
           ;; try submod first:
           `(submod ,spec reader)
           ;; fall back to /lang/reader:
           (string->symbol (string-append (symbol->string spec) "/lang/reader"))))]
        [(string? spec)
         (and
          (module-path? spec)
          (vector-immutable
           `(submod ,spec reader)))]
        [else #f]))

(define (id v) v)

(define-values [-read -read-syntax -get-info]
  (make-meta-reader
   'gnal
   "language path"
   #:read-spec read-spec
   reader-mod-paths
   id
   id
   id))

