#lang rosette/safe

(require rosutil)

(provide R)

(define (R f circuit)
  (and 
	(equal? (get-field circuit 'cur_bit_ind) (bv 0 6))
	(equal? (get-field circuit 'want_next) (bv 1 1))
  )
)