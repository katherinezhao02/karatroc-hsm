/* verilator lint_off PINMISSING */

module pwhash #(
    parameter FIRMWARE_FILE = "fw/pwhash.mem",
    parameter ROM_ADDR_BITS = 12, // 4K ROM
    parameter RAM_ADDR_BITS = 12, // 4K RAM
    parameter FRAM_ADDR_BITS = 12 // 4k FRAM
) (
    input clk,
    input resetn,
    input rx,
    input cts,
    output tx,
    output rts,
    input trng_bit,
    output trng_req
);

wrapper #(
    .FIRMWARE_FILE (FIRMWARE_FILE),
    .ROM_ADDR_BITS (ROM_ADDR_BITS),
    .RAM_ADDR_BITS (RAM_ADDR_BITS),
    .FRAM_ADDR_BITS (FRAM_ADDR_BITS)
) wrapper (
    .clk (clk),
    .resetn (resetn),
    .uart_tx (tx),
    .uart_rx (rx),
    .uart_cts (cts),
    .uart_rts (rts),
    .trng_bit (trng_bit),
    .trng_req (trng_req)
);

endmodule
