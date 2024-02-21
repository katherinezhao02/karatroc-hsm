#lang knox/spec

#:init s0
#:symbolic-constructor new-symbolic-state
#:methods
(get-random)
#:leak #f
#:random #t
#:max-trng-bits 10

;; stateless
(define (new-symbolic-state)
  (void))

(define s0 (void))

(define (make-word t n) 
  (if (equal? n 1)
    (bool->bitvector (car t) 1)
    (concat (bool->bitvector (car t) 1) (make-word (cdr t) (- n 1)))
  )
)

(define ((get-random) s)
  (define t (rstate-trng s))
  ; (result (make-word t 4) (cons (car s) (cdr (cdr (cdr (cdr t))))))
  (result (make-word t 2) (rstate (rstate-spec s) (cdr (cdr t))))
  )