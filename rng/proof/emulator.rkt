#lang knox/emulator

(define (init)
  (let ([c (update-fields (circuit-new)
                    (list
                     (cons 'want_next (bv 1 1))
                     ))])
    ; (printf "circuit after updating in init ~v ~n" c)
    (set! c)))

(define (with-input i)
  (set! (circuit-with-input (get) i)))

(define (get-output)
  (circuit-get-output (get)))

(define (step)
  (set! (circuit-step (get))))