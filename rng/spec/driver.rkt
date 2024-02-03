#lang knox/driver

#:idle [en #f]

(define (get-random)
  (out* 'en #t 'req #t) ; write hints to concretize
  ; (hint debug)
  (hint concretize)
  ; (hint debug)
  (tick)
  ; (printf "driver: ~v ~n" (in))
  (tick)
  (tick)
  (tick)
  ; (printf "driver: ~v ~n" (in))
  (let ([r (output-random_word (in))])
    (tick)
    ; (printf "driver: ~v ~n" (in))
    r)
  )