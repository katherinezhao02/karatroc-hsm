#lang knox/emulator

(define (init)
  (let ([c (update-fields (circuit-new)
                    (list
                     (cons 'want_next (bv 0 1))
                     ))])
    ; (printf "circuit after updating in init ~v ~n" c)
    (set! c)))

(define (with-input i)
  (set! (circuit-with-input (get) i)))

(define (get-output)
  (circuit-get-output (get)))

(define (step)
  (set! (if (and (equal? (get-field (circuit-step (get)) 'valid) (bv 1 1)) (get-field (circuit-step (get)) 'en))
    (update-field (circuit-step (get)) 'cur_word (spec:get-random)) (circuit-step (get)))))