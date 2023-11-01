#lang knox/driver

#:idle [en #f]

(define (multiply x)
  (printf "driver multiply x:~v ~n" x)
  (out* 'en #t 'x x)
  (printf "before tick driver multiply ~v ~n" x)
  (tick)
  (out* 'en #t)
  (tick)
  (printf "done driver multiply ~v ~n" x)
  )

(define (get-overflow)
  (out* 'en #f)
  (tick)
  (output-overflow (in)))

(define (get-total)
  (out* 'en #f)
  (tick)
  (output-out (in)))