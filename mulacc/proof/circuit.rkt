#lang knox/circuit

#:circuit "mulacc.rkt"
#:reset reset #t
#:persistent [acc ovf]
#:init-zeroed [acc ovf]
#:init-with-val [[acc (bv 1 32)]]