#lang knox/security

#:spec "../spec/spec.rkt"
#:circuit "circuit.rkt"
#:emulator "emulator.rkt"
#:R R

(require "shared.rkt" rosette/safe rosutil)

(printf "circuit ~v ~n" (lens-view (lens 'term 'circuit) (current)))

(step!)
(printf "circuit after step ~v ~n" (lens-view (lens 'term 'circuit) (current)))

(subsumed! 0)