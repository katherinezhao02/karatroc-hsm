#lang knox/circuit

#:circuit "rng.rkt"
#:reset resetn #f
#:persistent [wrapper.soc.rom.rom wrapper.soc.fram.fram]
#:init-zeroed [wrapper.soc.fram.fram]
#:trng-word trng_word
#:trng-req trng_req
#:trng-valid trng_valid
