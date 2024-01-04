#lang knox/spec

#:init s0
#:symbolic-constructor new-symbolic-state
#:methods
(get-random)
#:leak #f

;; stateless
(define (new-symbolic-state)
  (void))

(define s0 (void))

(define ((get-random) s)
  (define t (cdr s))
  (result (car t) 
    (cons (car s) (cdr t)))
  ; (result (concat (car (cdr t)) (car t)) 
  ;   (cons (car s) (cdr (cdr t))))

  ; (result (concat (car (cdr (cdr (cdr t)))) (car (cdr (cdr t))) (car (cdr t)) (car t)) 
  ;   (cons (car s) (cdr (cdr (cdr (cdr t))))))
  )