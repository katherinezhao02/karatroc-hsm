#include "drivers.h"
#include <stddef.h>

#define DIVISOR 6

uint32_t *state = (uint32_t *) FRAM_BASE;

// API
#define CMD_GET_RANDOM (0x01) // (4 bytes in little-endian encoding) -> ()

void do_get_random();

void main() {
    uart_init(UART1, DIVISOR);
    uint8_t cmd = uart_read(UART1);
    switch (cmd) {
    case CMD_GET_RANDOM:
      do_get_random();
      break;
    default:
      break;
    }
    poweroff(); // done, don't interact with world any more until next reset
}

void do_get_random() {
  uint32_t n = 0;
  trng_write(1);
  n |= ((uint32_t) trng_read()) << 4;
  trng_write(1);
  n |= ((uint32_t) trng_read());
  uart_write(UART1, n);
}

void do_add() {
  uint32_t n = 0;
  for (int i = 0; i < 4; i++) {
    n |= ((uint32_t) uart_read(UART1)) << (8 * i);
  }
  uint32_t value = *state;
  uint32_t next = value + n;
  uint32_t not_overflow = next >= value;
  uint32_t mask = (not_overflow - 1);
  next |= mask;
  *state = next;
  uart_write(UART1, 0x01);
}

void do_get() {
  uint32_t n = *state;
  for (int i = 0; i < 4; i++) {
    uint32_t v = (n >> (8 * i)) & 0xff;
    uart_write(UART1, (uint8_t) v);
  }
}
