#lang racket
 
(module reader syntax/module-reader
  racket/base
  #:wrapper1 (lambda (t)
               (parameterize ([read-case-sensitive #f])
                 (t))))
