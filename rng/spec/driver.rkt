#lang knox/driver

#:idle [en #f]

(define (get-random)
  (out* 'en #t 'req #t)
  (tick)
  ; (tick)
  ; (tick)
  ; (tick)
  (output-random_word (in))
  )