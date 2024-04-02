#lang rosette/safe

(require rosutil
         "../spec/spec.rkt"
         "rng.rkt"
         (only-in racket/list range))

(provide AbsF R I)

;; gives spec state corresponding to a circuit state
(define (AbsF ci)
  ;; sizeof(struct entry) == 24 bytes, which is 6 entries in the vector (of 32-bit words)
  (define fram (get-field ci 'wrapper.soc.fram.fram))
  (vector-ref fram 0))

(define (R f ci)
  (I ci))

(define (I ci)
  (and
    (bveq (get-field ci 'wrapper.pwrmgr_state) (bv #b01 2))
    (bveq (get-field ci 'wrapper.soc.trngio.state) (bv #b00 2))
    (bveq (get-field ci 'wrapper.soc.trngio.ready) (bv #b0 1))
    (bveq (get-field ci 'wrapper.soc.trngio.trng_out) (bv #b0 1))
    ))
