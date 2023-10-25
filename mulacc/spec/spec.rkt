#lang knox/spec

#:init s0
#:symbolic-constructor new-symbolic-state
#:methods
(multiply [x (bitvector WIDTH)])
(get-overflow)
(get-total)
#:leak #f

(require rosutil)

(define WIDTH 32)

(struct state (total overflow))

(define s0
  (state (bv 1 WIDTH)
         (bv 0 1)))

(define (new-symbolic-state)
  (state
   (fresh-symbolic 'total (bitvector WIDTH))
   (fresh-symbolic 'overflow (bitvector 1))))

(define ((multiply x) s)
  (define prod (bvmul
              (zero-extend x (bitvector 64))
              (zero-extend (state-total s) (bitvector 64))))
  (define prod-ovf (extract 63 32 prod))
  ; (println prod)
  ; (println prod-ovf)
  (define ovf ;we have overflow if we already have overflow or we newly overflowed
    (if 
      (or 
        (equal? (state-overflow s) (bv 1 1)) 
        (bvugt prod-ovf (bv 0 32))
      )
      (bv 1 1)
      (bv 0 1)
    )
  )
  (result 
    (void)
    (state (extract 31 0 prod) ovf)
  )
)

(define ((get-overflow) s)
  (result
   (state-overflow s)
   s))

(define ((get-total) s)
  (result
   (state-total s)
   s))

(module+ test
  (require rackunit)

  (test-case "multiply"
    (define s1 (state (bv 1 WIDTH) (bv 0 1)))
    (define s2 (result-state ((multiply (bv 20 WIDTH)) s1)))
    (check-equal? (state-total s2) (bv 20 WIDTH))
    (check-equal? (state-overflow s2) (bv 0 1))

    (define s3 (result-state ((multiply (bv 429496729 WIDTH)) s2)))
    (check-equal? (state-overflow s3) (bv 1 1))

    (define s4 (result-state ((multiply (bv 0 WIDTH)) s3)))
    (check-equal? (state-overflow s4) (bv 1 1))

  )

  (test-case "multiply2"
    (define s1 (state (bv #xe00150be WIDTH) (bv 0 1)))
    (define s2 (result-state ((multiply (bv #x95fd3f7f WIDTH)) s1)))
    (check-equal? (state-overflow s2) (bv 1 1))

  )
)