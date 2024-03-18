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
(replace! (lens 'circuit 'want_next) (bv 0 1))
(replace! (lens 'circuit 'is_valid) (bv 0 1))
(replace! (lens 'circuit 'cur_word) (bv 0 8))
(replace! (lens 'circuit 'reset_ind) (bv 0 1))
(overapproximate-predicate! #t)


(printf "~n circuit 1 ~v ~n" (lens-view (lens 'term 'circuit) (current)))
(printf "emulator auxiliary1 ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))
(printf "emulator oracle 1 ~v ~n" (lens-view (lens 'term 'emulator 'oracle) (current)))
(define init_oracle (lens-view (lens 'term 'emulator 'oracle) (current)))
(define init_trng (lens-view (lens 'term 'emulator 'oracle 'trng) (current)))
(printf "emulator trng 1 ~v ~n" init_trng)


(define (step-en!)
  (define prev-index (length (visited)))
  (step!)
  ;; case split based on whether en was true
  (define en (lens-view (lens 'term 'circuit 'en) (current)))
  (cases! (list (! en) en))
  ;; when not en, nothing has changed
  (subsumed! prev-index)
  )

(define (step-en-valid!)
  (define prev-index (length (visited)))
  (step!)
  ;; case split based on whether en was true
  (define en (lens-view (lens 'term 'circuit 'en) (current)))
  (cases! (list (! en) en))
  ;; when not en, nothing has changed
  (subsumed! prev-index)
  (define val (lens-view (lens 'term 'circuit 'trng_valid) (current)))
  (cases! (list (! val) val))
  (subsumed! prev-index)
  )

(define (concr_all)
	(concretize! (lens 'circuit 'cur_bit_ind))
	(concretize! (lens 'emulator 'auxiliary 'cur_bit_ind))
	(concretize! (lens 'circuit 'is_valid))
	(concretize! (lens 'emulator 'auxiliary 'is_valid))
	(concretize! (lens 'circuit 'cur_word))
	(concretize! (lens 'emulator 'auxiliary 'cur_word))
	(concretize! (lens 'circuit 'reset_ind))
	(concretize! (lens 'emulator 'auxiliary 'reset_ind))
	(concretize! (lens 'circuit 'want_next))
	(concretize! (lens 'emulator 'auxiliary 'want_next))
	)

(step-en!)
(printf "~n circuit 1.1 ~v ~n" (lens-view (lens 'term 'circuit) (current)))
(printf "emulator auxiliary1.1 ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))
(printf "emulator oracle 1.1 ~v ~n" (lens-view (lens 'term 'emulator 'oracle) (current)))
(printf "circuit trng 1.1 ~v ~n" (lens-view (lens 'circuit-trng-state) (current)))

(step-en-valid!)
(printf "~n circuit 2 ~v ~n" (lens-view (lens 'term 'circuit) (current)))
(printf "emulator auxiliary2 ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))
(printf "emulator oracle 2 ~v ~n" (lens-view (lens 'term 'emulator 'oracle) (current)))
(printf "circuit trng 2 ~v ~n" (lens-view (lens 'circuit-trng-state) (current)))
(replace-circuit-trng! (cdr init_trng))
(step-en-valid!)
(replace-circuit-trng! (cdr (cdr init_trng)))
(step-en!)
(subsumed! 0)
; (step-en!)
; (step-en!)
; (step-en!)
#|
(replace-circuit-trng! (cdr init_trng))
(define req (lens-view (lens 'term 'circuit 'req) (current)))
(cases! (list req (! req)))
(concr_all)
; (define cur_oracle (lens-view (lens 'term 'emulator 'oracle) (current)))
(define updated_trng (cdr (cdr init_trng)))
(replace! (lens 'emulator 'oracle 'trng) updated_trng)
; (printf "~n circuit 2.1 ~v ~n" (lens-view (lens 'term 'circuit) (current)))
; (printf "emulator auxiliary2.1 ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))
; (printf "emulator oracle 2.1 ~v ~n" (lens-view (lens 'term 'emulator 'oracle) (current)))
(step-en!)

(concr_all)

; (printf "~n circuit 3 ~v ~n" (lens-view (lens 'term 'circuit) (current)))
; (printf "emulator auxiliary3 ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))
; (printf "emulator oracle 3 ~v ~n" (lens-view (lens 'term 'emulator 'oracle) (current)))
; (printf "circuit trng 3 ~v ~n" (lens-view (lens 'circuit-trng-state) (current)))

;; if we request we reset the circuit
(subsumed! 0)
; (print "done first subsumed ~n")

(concr_all)
(replace! (lens 'emulator 'oracle 'trng) init_trng)
; (printf "~n circuit 3.1 ~v ~n" (lens-view (lens 'term 'circuit) (current)))
; (printf "emulator auxiliary3.1 ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))
; (printf "emulator oracle 3.1 ~v ~n" (lens-view (lens 'term 'emulator 'oracle) (current)))
; (printf "circuit trng 3.1 ~v ~n" (lens-view (lens 'circuit-trng-state) (current)))

;; if we don't request we hold onto the word
(define req-index (length (visited)))
(replace-circuit-trng! (cdr init_trng))
(step-en!)

(define req2 (lens-view (lens 'term 'circuit 'req) (current)))
(cases! (list req2 (! req2)))
(replace! (lens 'emulator 'oracle 'trng) updated_trng)
; (printf "~n circuit 4 ~v ~n" (lens-view (lens 'term 'circuit) (current)))
; (printf "emulator auxiliary4 ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))
; (printf "emulator oracle 4 ~v ~n" (lens-view (lens 'term 'emulator 'oracle) (current)))
; (printf "circuit trng 4 ~v ~n" (lens-view (lens 'circuit-trng-state) (current)))
; (printf "pred ~v ~n" (lens-view (lens 'predicate) (current)))

(replace-circuit-trng! updated_trng)
(step-en!)

(replace! (lens 'emulator 'oracle 'trng) updated_trng)
(subsumed! 0)
(concr_all)
; (printf "here ~n")
; (printf "~n circuit 5 ~v ~n" (lens-view (lens 'term 'circuit) (current)))
; (printf "emulator auxiliary5 ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))
; (printf "emulator oracle 5 ~v ~n" (lens-view (lens 'term 'emulator 'oracle) (current)))
; (printf "circuit trng 5 ~v ~n" (lens-view (lens 'circuit-trng-state) (current)))
; (printf "pred ~v ~n" (lens-view (lens 'predicate) (current)))
(replace! (lens 'emulator 'oracle 'trng) init_trng)
(subsumed! req-index)
|#
