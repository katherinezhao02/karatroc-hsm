#lang knox/circuit

#:circuit "rng.rkt"
#:reset reset #t
#:persistent [cur_word cur_bit_ind]
#:init-zeroed [cur_word cur_bit_ind]
#:trng-bit trng_bit
#:trng-next trng_next