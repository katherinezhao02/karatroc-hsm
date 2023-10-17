#lang knox/emulator

(define (init)
  (let ([c (update-fields (circuit-new)
                    (list
                     (cons 'acc (spec:get-total))
                     (cons 'ovf (spec:get-overflow))
                     ))])
    (set! c)))

(define (with-input i)
  (set! (circuit-with-input (get) i)))

(define (get-output)
  (circuit-get-output (get)))

(define (step)
  (set! (circuit-step (get))))