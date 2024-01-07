#lang knox/correctness

#:spec "../spec/spec.rkt"
#:circuit "circuit.rkt"
#:driver "../spec/driver.rkt"
#:R R
#:verbose #t
#:max-trng-bits 5

(require "shared.rkt")
