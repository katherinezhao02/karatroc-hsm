#lang knox/security

#:spec "../spec/spec.rkt"
#:circuit "circuit.rkt"
#:emulator "emulator.rkt"
#:R R

(require "shared.rkt" rosette/safe rosutil)

(printf "circuit ~v ~n" (lens-view (lens 'term 'circuit) (current)))
(printf "~n pred ~v ~n" (lens-view (lens 'predicate) (current)))
(printf "emulator auxiliary ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))
(printf "emulator oracle ~v ~n" (lens-view (lens 'term 'emulator 'oracle) (current)))


(define (step-en!)
  (define prev-index (length (visited)))
  (step!)
  ;; case split based on whether en was true
  (define en (lens-view (lens 'term 'circuit 'en) (current)))
  (cases! (list (! en) en))
  ;; when not en, nothing has changed
  (subsumed! prev-index)
  )

(replace! (lens 'emulator 'auxiliary 'acc) (lens-view (lens 'term 'circuit 'acc) (current)))
(replace! (lens 'emulator 'auxiliary 'out) (lens-view (lens 'term 'circuit 'acc) (current)))
(replace! (lens 'emulator 'auxiliary 'ovf) (lens-view (lens 'term 'circuit 'ovf) (current)))
(replace! (lens 'emulator 'oracle 'overflow) (lens-view (lens 'term 'circuit 'ovf) (current)))
(replace! (lens 'emulator 'oracle 'total) (lens-view (lens 'term 'circuit 'acc) (current)))
(replace! (lens 'circuit 'out) (lens-view (lens 'term 'circuit 'acc) (current)))

(concretize! (lens 'circuit 'state))
(overapproximate!
 (lens 'emulator 'auxiliary (list 'extra 'x 'en 'tmp_x)))
(overapproximate-predicate! #t)

(printf "~n circuit begin ~v ~n" (lens-view (lens 'term 'circuit) (current)))
(printf "~n pred ~v ~n" (lens-view (lens 'predicate) (current)))
(printf "emulator auxiliary ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))
(printf "emulator oracle ~v ~n" (lens-view (lens 'term 'emulator 'oracle) (current)))


(define overflow (lens-view (lens 'term 'circuit 'ovf) (current)))
; (cases! (list (equal? overflow (bv 1 1)) (!(equal? overflow (bv 1 1)))))
; (concretize! (lens 'emulator 'auxiliary 'ovf))
; (concretize! (lens 'emulator 'oracle 'overflow))
; (concretize! (lens 'circuit 'ovf))
(printf "~n circuit after cases ~v ~n" (lens-view (lens 'term 'circuit) (current)))
(printf "~n pred ~v ~n" (lens-view (lens 'predicate) (current)))
(printf "emulator auxiliary ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))
(printf "emulator oracle ~v ~n" (lens-view (lens 'term 'emulator 'oracle) (current)))


(step-en!)
(printf "~n circuit after step1 ~v ~n" (lens-view (lens 'term 'circuit) (current)))
(printf "~n pred ~v ~n" (lens-view (lens 'predicate) (current)))
(printf "emulator auxiliary ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))
(printf "emulator oracle ~v ~n" (lens-view (lens 'term 'emulator 'oracle) (current)))

(concretize! (lens 'circuit 'state))
(concretize! (lens 'emulator 'auxiliary 'state))


(step-en!)
(concretize! (lens 'circuit 'state))
(concretize! (lens 'emulator 'auxiliary 'state))
(printf "~n circuit after step2 ~v ~n" (lens-view (lens 'term 'circuit) (current)))
(printf "~n pred ~v ~n" (lens-view (lens 'predicate) (current)))
(printf "emulator auxiliary ~v ~n" (lens-view (lens 'term 'emulator 'auxiliary) (current)))
(printf "emulator oracle ~v ~n" (lens-view (lens 'term 'emulator 'oracle) (current)))
(replace! (lens 'emulator 'oracle 'total) (lens-view (lens 'term 'circuit 'acc) (current)))

(subsumed! 0)