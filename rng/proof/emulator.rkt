#lang knox/emulator

(struct state (num-trng circuit))

(define (init)
  (set! (state 0 (circuit-new))))

(define (with-input i)
  (set! (state (state-num-trng (get)) (circuit-with-input (state-circuit (get)) i))))

(define (get-output)
  (circuit-get-output (state-circuit (get))))

(define (step)
  (let ([c (circuit-step (state-circuit (get)))]
        [t (state-num-trng (get))])
    (if (and
         (equal? (get-field c 'valid) (bv 1 1))
         (get-field c 'en)
         )
        (set! (state (- t 8) (update-field c 'cur_word (spec:get-random))))
        (set! (state t c))))

  (let ([c (state-circuit (get))]
        [t (state-num-trng (get))])
    (if (and
         (equal? (get-field c 'want_next) (bv 1 1))
         (get-field c 'en))
        (set! (state (+ t 1) c))
        (void)))
)

(define (shutdown)
  (spec:leak (state-num-trng (get)))
  )

