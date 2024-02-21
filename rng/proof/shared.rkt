#lang rosette/safe

(require rosutil)

(provide R)

(define (R f circuit)
  (and 
	(equal? (get-field circuit 'cur_bit_ind) (bv 0 6))
	(equal? (get-field circuit 'want_next) (bv 0 1))
	(equal? (get-field circuit 'valid) (bv 0 1))
	(equal? (get-field circuit 'cur_word) (bv 0 2))
	(equal? (get-field circuit 'reset_ind) (bv 0 1))
  )
)