#lang rosette/safe

(require rosutil)

(provide R)

(define (R f circuit)
;;case 1: overflow: then both have overflow
;;case 2: no overflow: then both do not have overflow and totals are equal
  (and 
  	(equal? 
  		(get-field f 'overflow) 
  		(get-field circuit 'ovf) 
	)
	(if 
		(equal? (get-field f 'overflow) (bv 0 1))
		(equal? (get-field f 'total) (get-field circuit 'acc))
		#t
	)
  )
)