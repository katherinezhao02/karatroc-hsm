`timescale 1 ns / 1 ps

module trngio #(
    parameter [31:0] ADDR = 32'hffff_ffff,
    parameter TRNG_WIDTH = 4
) (
    input clk,
    input resetn,
    input mem_valid,
    input [31:0] mem_addr,
    input [31:0] mem_wdata,
    input [3:0] mem_wstrb,
    output trngio_ready,
    output trngio_sel,
    output [31:0] trngio_rdata,
    input [TRNG_WIDTH-1:0] trng_word,
    input trng_valid,
    output trng_req
);

wire reg_read_sel = mem_valid && (mem_addr == ADDR);
assign trngio_sel = reg_read_sel;


reg [1:0] state; 
reg ready;
reg [TRNG_WIDTH-1:0] trng_word_reg;
reg trng_out;

always @(posedge clk) begin
    if (!resetn) begin
        trng_out <= 0;
        trng_word_reg <= 0;
        state <= 0;
        ready <= 0;
    end else begin
        if (state == 0) begin
            ready <= 0;
            trng_word_reg <= 0;
            if (reg_read_sel) begin
                trng_out <= 1;
                state <= 1;
            end
        end else if (state == 1 && trng_valid) begin
            trng_out <= 0;
            trng_word_reg <= trng_word;
            ready <= 1;
            state <= 2;
        end else if (state == 2) begin
            ready <= 0;
            trng_word_reg <= 0;
            state <= 0;
        end
    end 
end
assign trngio_ready = ready;
assign trngio_rdata = {(32-TRNG_WIDTH)'h0, trng_word_reg};
assign trng_req = trng_out;

endmodule