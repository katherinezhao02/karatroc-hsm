#lang knox/correctness

#:spec "../spec/spec.rkt"
#:circuit "circuit.rkt"
#:driver "../spec/driver.rkt"
#:R R
#:hints hints
#:verbose #t

(require "shared.rkt"
 knox/correctness/hint
 rosutil
 (except-in rosette/safe result-state result-value result?)
 racket/match)

(define debug
  (tactic
   (define s (get-state))
   (println (lens-view (lens 'interpreter 'globals 'circuit) s))))
(define hint-concretize
  (concretize! (lens 'circuit (field-filter/or "cur_bit_ind" "want_next" "is_valid" "cur_word" "reset_ind")) #:use-pc #t))


(define (hints method c1 f1 f-out f2)
  (match method
    [`(get-random)
     (make-hintdb
      [debug debug]
      [concretize hint-concretize])]))
