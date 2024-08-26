#include "drivers.h"
#include <stdbool.h>

#define BAUD_RATE 6
#define SECRET_SIZE 20
#define MESSAGE_SIZE 32

struct state {
    uint32_t active;
    uint8_t secret0[SECRET_SIZE];
    uint8_t secret1[SECRET_SIZE];
} *state = (struct state *) FRAM_BASE;

#define CMD_SET_SECRET (0x01)
#define CMD_GET_HASH (0x02)

void do_set_secret(uint8_t *secret);
void do_get_hash(uint8_t *buf);

uint8_t digest[SHA256_DIGEST_SIZE];

void main() {
    uart_init(UART1, BAUD_RATE);
    uint8_t cmd = uart_read(UART1);
    uint8_t buf[SECRET_SIZE + MESSAGE_SIZE];
    uint8_t secret[SECRET_SIZE];
    for (int i = 0; i < MESSAGE_SIZE; i++) {
        buf[SECRET_SIZE + i] = uart_read(UART1);
    }
    for (int i=0; i<SECRET_SIZE; i++) {
        secret[i]=((uint8_t) trng_read());
    }
    switch (cmd) {
        case CMD_SET_SECRET:
            do_set_secret(secret);
            break;
        case CMD_GET_HASH:
            do_get_hash(buf);
            break;
        default:
            for (int i = 0; i < sizeof(digest); i++) {
                digest[i] = 0;
            }
            break;
    }
    uart_write(UART1, 0x01);
    for (int i = 0; i < sizeof(digest); i++) {
        uart_write(UART1, digest[i]);
    }
    poweroff(); // done, don't interact with world any more until next reset
}

void memcpy(uint8_t *dest, const uint8_t *src, size_t sz) {
    for (int i = 0; i < sz; i++) {
        dest[i] = src[i];
    }
}

// written this way, it turns into branch-free code (= constant time)
uint8_t *get_active() {
    uint8_t *base = state->secret0;
    uint32_t zlt = 0 < state->active;
    zlt = zlt * SECRET_SIZE;
    base = base + zlt;
    return base;
}

// written this way, it turns into branch-free code (= constant time)
uint8_t *get_inactive() {
    uint8_t *base = state->secret0;
    uint32_t zlt = 0 < state->active;
    zlt = 1 - zlt;
    zlt = zlt * SECRET_SIZE;
    base = base + zlt;
    return base;
}

void do_set_secret(uint8_t *secret) {
    // write into inactive region, then make active
    uint8_t *dest = get_inactive();
    memcpy(dest, secret, SECRET_SIZE);
    state->active = !state->active;
    for (int i = 0; i < sizeof(digest); i++) {
        digest[i] = 0;
    }
    for (int i = 0; i < 145; i++) {
        asm volatile(
            "beq zero, zero, 0f \n\t"
            "0: \n\t"
        );
    }
}

void do_get_hash(uint8_t *buf) {
    uint8_t *secret = get_active();
    memcpy(buf, secret, SECRET_SIZE);
    sha256_digest(SHA256, buf, SECRET_SIZE + MESSAGE_SIZE, digest);
}
