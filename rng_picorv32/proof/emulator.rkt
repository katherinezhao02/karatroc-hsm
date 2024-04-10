#lang knox/emulator

(struct state (circuit))

(define (initial-circuit)
  (circuit-with-input
   (circuit-step
    (circuit-with-input
     (circuit-new)
     (input* 'resetn #f 'cts #t 'rx #t)))
   (input* 'resetn #t 'cts #t 'rx #t)))

(define (init)
  (set! (state (initial-circuit))))

(define (with-input i)
  (set! (state (circuit-with-input (state-circuit (get)) i))))

(define (get-output)
  (circuit-get-output (state-circuit (get))))

(define (swap32 b)
  (concat
   (extract 7 0 b)
   (extract 15 8 b)
   (extract 23 16 b)
   (extract 31 24 b)))

(define (step)
  ;; get-random
  (let ([c (state-circuit (get))])
    (if (and
         (equal? (get-field c 'wrapper.pwrmgr_state) (bv #b10 2))
         (equal? (get-field c 'wrapper.soc.cpu.reg_pc) (bv #xe4 32))
         (equal? (get-field c 'wrapper.soc.cpu.cpu_state) (bv #x40 8))
         ;(equal? (get-field c 'wrapper.soc.cpu.mem_state) (bv #b10 2))
         )
        (let ([regs (vector-set (get-field c 'wrapper.soc.cpu.cpuregs) 11 (concat (bv #x000000 24) (spec:get-random)))])
          (displayln "get-random triggered")
          (printf "regs: ~v~n" regs)
          (set! (state (update-field c 'wrapper.soc.cpu.cpuregs regs))))
        (void)))

  ; ;; zero out fram at poweroff
  (let ([c (state-circuit (get))])
    (if (and
         (equal? (get-field c 'wrapper.pwrmgr_state) (bv #b10 2))
         (equal? (get-field c 'wrapper.soc.cpu.reg_pc) (bv #xac 32)))
        (set! (state (update-field c 'wrapper.soc.fram.fram (get-field (circuit-zeroed) 'wrapper.soc.fram.fram))))
        (void)))

  (set! (state (circuit-step (state-circuit (get))))))
