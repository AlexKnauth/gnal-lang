#lang racket/base

(provide (rename-out [-read read]
                     [-read-syntax read-syntax]
                     [-get-info get-info]))

(require (only-in syntax/module-reader make-meta-reader))

(define (read-spec in)
  (read in))

;; reader-mod-paths : Any -> (U False (Vectorof Module-Path))
(define (reader-mod-paths spec)
  (cond [(symbol? spec)
         (reader-mod-paths/symbol spec)]
        [(string? spec)
         (reader-mod-paths/string spec)]
        [else #f]))

;; reader-mod-paths/symbol : Symbol -> (U False (Vectorof Module-Path))
(define (reader-mod-paths/symbol sym)
  ;; using my-collection-file-path is necessary for converting it to a string,
  ;; so that it can support unicode characters
  (mod-paths
   ;; try submod first:
   (submod-reader (my-collection-file-path sym #:fail (λ (err) #f)))
   ;; fall back to /lang/reader:
   (my-collection-file-path (symbol/lang/reader sym) #:fail (λ (err) #f))))

;; reader-mod-paths/string : String -> (U False (Vectorof Module-Path))
(define (reader-mod-paths/string str)
  (vector-immutable
   (submod-reader (file str))
   (file (string-append str "/lang/reader.rkt"))))

;; id : A -> A
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (my-collection-file-path sym #:fail fail)
  (define str (symbol->string sym))
  (cond
    [(regexp-match? #rx"/" str)
     (define-values [base name must-be-dir?]
       (split-path (string-append str ".rkt")))
     (collection-file-path name base #:fail fail)]
    [else
     (collection-file-path "main.rkt" str #:fail fail)]))

;; mod-paths : Any Any -> (U False (Vectorof Module-Path))
(define (mod-paths v1 v2)
  (cond [(and (module-path? v1) (module-path? v2)) (vector-immutable v1 v2)]
        [(module-path? v1) (vector-immutable v1)]
        [(module-path? v2) (vector-immutable v2)]
        [else #f]))

;; submod-reader : Module-Path -> Module-Path
(define (submod-reader mod)
  `(submod ,mod reader))

;; file : String -> Module-Path
(define (file str)
  `(file ,str))

;; symbol/lang/reader : Symbol -> Symbol
(define (symbol/lang/reader sym)
  (string->symbol (string-append (symbol->string sym) "/lang/reader")))



