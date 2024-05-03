#lang knox/driver

#:idle [en #f]

(define (tick-n n)
  (if (zero? n)
      (void)
      (begin
        (tick)
        (tick-n (sub1 n)))))

(define (get-random)
  (out* 'en #t 'req #t) 
  (hint concretize)
  (tick-n 8)
  (let ([r (output-random_word (in))])
    (tick)
    r)
  )