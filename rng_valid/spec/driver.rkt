#lang knox/driver

#:idle [en #f]

(define (get-random)
  (out* 'en #t) ; write hints to concretize
  ; (hint debug)
  (hint concretize)
  ; (hint debug)
  ; (printf "driver0 ~v ~n" (output-trng_req (in)))
  (tick)
  ; (printf "driver1 ~v ~n" (output-trng_req (in)))
  ; (hint debug)
  ; (printf "driver: ~v ~n" (in))
  ; (printf "driver2 ~v ~n" (output-trng_req (in)))
  ; (hint debug)
  (tick)
  (tick)
  ; (tick)
  ; (tick)
  ; (tick)
  ; (printf "driver: ~v ~n" (in))
  (let ([r (output-random_word (in))])
    (tick)
    ; (printf "driver: ~v ~n" (in))
    r)
  )