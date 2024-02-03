#lang knox/security

#:spec "../spec/spec.rkt"
#:circuit "circuit.rkt"
#:emulator "emulator.rkt"
#:R R

(require "shared.rkt" rosette/safe rosutil)

(require "shared.rkt"
         rosutil
         rosette/safe)

; (printf "circuit ~v ~n" (lens-view (lens 'term 'circuit) (current)))
; (printf "emulator auxiliary ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))

(replace! (lens 'circuit 'cur_bit_ind) (bv 0 6))
(replace! (lens 'circuit 'want_next) (bv 1 1))
(replace! (lens 'circuit 'valid) (bv 0 1))
(replace! (lens 'circuit 'cur_word) (bv 0 4))
(replace! (lens 'circuit 'reset_ind) (bv 0 1))

; (printf "~n circuit 1 ~v ~n" (lens-view (lens 'term 'circuit) (current)))
; (printf "emulator auxiliary1 ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))

(define (step-en!)
  (define prev-index (length (visited)))
  (step!)
  ;; case split based on whether en was true
  (define en (lens-view (lens 'term 'circuit 'en) (current)))
  (cases! (list (! en) en))
  ;; when not en, nothing has changed
  (subsumed! prev-index)
  (concretize! (lens 'circuit 'cur_bit_ind))
  (concretize! (lens 'emulator 'auxiliary 'cur_bit_ind))
  (concretize! (lens 'circuit 'valid))
  (concretize! (lens 'emulator 'auxiliary 'valid))
  )

(step-en!)


; (printf "~n circuit 2 ~v ~n" (lens-view (lens 'term 'circuit) (current)))
; (printf "emulator auxiliary2 ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))
(step-en!)
(step-en!)
(step-en!)
; (printf "~n circuit 3 ~v ~n" (lens-view (lens 'term 'circuit) (current)))
; (printf "emulator auxiliary3 ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))
(define req (lens-view (lens 'term 'circuit 'req) (current)))
(step-en!)
(cases! (list req (! req)))

;; if we request we reset the circuit
; (printf "~n circuit 4 ~v ~n" (lens-view (lens 'term 'circuit) (current)))
; (printf "emulator auxiliary4 ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))
(subsumed! 0)

;; if we don't request we hold onto the word
(define req2 (lens-view (lens 'term 'circuit 'req) (current)))
(define req-index (length (visited)))
(step-en!)
(cases! (list req2 (! req2)))

(subsumed! 0)
(subsumed! req-index)