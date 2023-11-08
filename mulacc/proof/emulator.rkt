#lang knox/emulator

(define (init)
  ; (printf "new circuit ~v ~n" (circuit-new))
  (let ([c (update-fields (circuit-new)
                    (list
                     (cons 'acc (spec:get-total))
                     (cons 'ovf (if (spec:get-overflow) (bv 1 1) (bv 0 1)))
                     (cons 'out (spec:get-total))
                     ))])
    ; (printf "circuit after updating in init ~v ~n" c)
    (set! c)))

(define (with-input i)
  (set! (circuit-with-input (get) i)))

(define (get-output)
  ; (printf "emulator output ~v ~n" (circuit-get-output (get)))
  (circuit-get-output (get)))

(define (step)
  (if (and (get-field (get) 'en) (bveq (get-field (get) 'state) (bv 1 1)))
      (spec:multiply (get-field (get) 'x))
      (void))
  (set! (circuit-step (get))))