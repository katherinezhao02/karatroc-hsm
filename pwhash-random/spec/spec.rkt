#lang knox/spec

#:init s0
#:symbolic-constructor new-symbolic-state
#:methods
(set-secret)
(get-hash [msg (bitvector MESSAGE-SIZE)])
#:random #t
#:max-trng-words 21
#:trng-word-length 8

(require rosutil
         (only-in "spec-sha256.rkt" sha256))

(provide
 SECRET-SIZE
 SECRET-SIZE-BYTES
 MESSAGE-SIZE
 MESSAGE-SIZE-BYTES
 new-symbolic-state
 set-secret
 get-hash
 s0)

(define SECRET-SIZE-BYTES 20)
(define SECRET-SIZE (* 8 SECRET-SIZE-BYTES))
(define MESSAGE-SIZE-BYTES 32)
(define MESSAGE-SIZE (* 8 MESSAGE-SIZE-BYTES))

(define (new-symbolic-state)
  (fresh-symbolic 'secret (bitvector SECRET-SIZE)))

(define (make-word t n) 
  (if (equal? n 1)
    (car t)
    (concat (car t) (make-word (cdr t) (- n 1)))
  )
)

(define (update-trng t n) 
  (if (equal? n 0)
    t
    (update-trng (cdr t) (- n 1))))

(define ((set-secret) s)
  (define t (rstate-trng s))
  (define secr (make-word t SECRET-SIZE-BYTES))
  (define new-t (update-trng t SECRET-SIZE-BYTES))
  (result #t (rstate secr new-t)))

(define ((get-hash msg) s)
  (define secr (rstate-spec s))
  (result (sha256 (concat secr msg)) s))

(define s0 (bv 0 SECRET-SIZE))

; (module+ test
;   (require rackunit)

;   (test-case "basic"
;     (define s0 (bv 0 SECRET-SIZE))
;     (define s1 (result-state ((set-secret (bv 1337 SECRET-SIZE)) s0)))
;     (check-equal?
;      (result-value ((get-hash (bv #x0123456789abcdef MESSAGE-SIZE)) s1))
;      (bv #xc4162593dac170ed49fe1a7aca6837761be71e95d470407696a1666790d967ab 256))))
