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
   (fresh-symbolic 'overflow (bitvector WIDTH))))

(define ((multiply x) s)
  (define prod (bvmul
              (sign-extend x (bitvector 63))
              (sign-extend (state-total s) (bitvector 63))))
  (define prod-ovf (extract 62 32 prod))
  (define ovf ;we have overflow if we already have overflow or we newly overflowed
    (if 
      (or 
        (equal? (state-overflow) (bv 1 1)) 
        (bvsgt prod-ovf (bv 0 31))
      )
      (bv 1 1)
      (bv 1 0)
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