#lang knox/security

#:spec "../spec/spec.rkt"
#:circuit "circuit.rkt"
#:emulator "emulator.rkt"
#:R R

(require "shared.rkt" rosette/safe rosutil)

(require "shared.rkt"
         rosutil
         rosette/safe)

(define (concretize-all!)
  (define to-concretize (list
                          'cur_bit_ind
                          'want_next
                          'valid
                          'reset_ind))
  (concretize! (lens (list (lens 'circuit to-concretize)
                                   (lens 'emulator 'auxiliary 'circuit to-concretize)))))

(define (step-en! [prepare #t])
  (define prev-index (length (visited)))
  (if prepare (prepare!) (void))
  (define en (lens-view (lens 'term 'circuit 'en) (current)))
  (cases! (list (! en) en))
  (overapproximate! (lens 'circuit 'cur_word))
  (overapproximate! (lens 'emulator 'auxiliary 'circuit 'cur_word))
  (step!)
  (concretize! (lens 'circuit 'en))
  (subsumed! prev-index)

  (concretize! (lens 'circuit 'en))
  (step!)
  )

(define (step-en-n! n)
  (unless (zero? n)
    (step-en!)
    ;(printf "step ~a, ~n" n)
    ;(printf "circuit trng ~v ~n" (lens-view (lens 'circuit-trng-state) (current)))
    (step-en-n! (sub1 n))))

(define (update-trng t n) 
  (if (equal? n 0)
    t
    (update-trng (cdr t) (- n 1))))

(define init_trng (lens-view (lens 'term 'emulator 'oracle 'trng) (current)))
(concretize-all!)
(concretize! (lens 'circuit 'cur_word))
(overapproximate-predicate! #t)

(step-en-n! 8)

(define req (lens-view (lens 'term 'circuit 'req) (current)))
(cases! (list req (! req)))
(concretize! (lens 'circuit 'req))
(concretize-all!)
;(printf "emulator ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary 'circuit) (current)))
;(printf "~v ~n" (lens-view (lens 'term 'emulator 'oracle 'trng) (current)))
(replace! (lens 'emulator 'oracle 'trng) (update-trng init_trng 8))
(replace-circuit-trng! (update-trng init_trng 8))
(step-en!)
(concretize-all!)
;; if we request we reset the circuit
;(printf "num ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary 'num-trng) (current)))
(subsumed! 0)

(concretize-all!)
(replace! (lens 'emulator 'oracle 'trng) init_trng)
;; if we don't request we hold onto the word
(define req-index (length (visited)))
(concretize! (lens 'emulator 'auxiliary 'num-trng))
(define focus-aux (lens-view (lens 'term 'emulator 'auxiliary 'circuit) (current)))
(replace-circuit-trng! (update-trng init_trng 7))
(prepare!)
(define req2 (lens-view (lens 'term 'circuit 'req) (current)))
(cases! (list req2 (! req2)))
(step-en! #f)
(replace! (lens 'emulator 'oracle 'trng) (update-trng init_trng 8))
(replace-circuit-trng! (update-trng init_trng 8))
(concretize-all!)
(step-en!)
(replace! (lens 'emulator 'oracle 'trng) (update-trng init_trng 8))
;(printf "num 2 ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary 'num-trng) (current)))
(subsumed! 0)

(step-en! #f)
(replace! (lens 'emulator 'oracle 'trng) init_trng)
(concretize! (lens 'emulator 'auxiliary 'num-trng))
(concretize-all!)
(subsumed! req-index)