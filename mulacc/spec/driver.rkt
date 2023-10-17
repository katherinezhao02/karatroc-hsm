#lang knox/driver

#:idle [en #f]

(define (multiply x)
  (out* 'en #t 'x x)
  (tick))

(define (get-overflow)
  (output-overflow (in)))

  (define (get-total)
  (output-out (in)))