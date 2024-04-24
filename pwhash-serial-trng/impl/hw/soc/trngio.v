`timescale 1 ns / 1 ps

module trngio #(
    parameter [31:0] ADDR = 32'hffff_ffff,
    parameter WIDTH = 8
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
    input trng_bit,
    output trng_req
);

wire reg_read_sel = mem_valid && (mem_addr == ADDR);
assign trngio_sel = reg_read_sel;

reg state; 
reg [WIDTH-1:0] trng_word_reg;
reg ready;
reg trng_out; 
reg [3:0] cur_bit_ind;
// always @(posedge clk) begin
//     if (!resetn) begin
//         trng_out <= 0;
//     end else begin
//         if (reg_read_sel) begin
//             trng_out <= 1;
//         end else begin
//             trng_out <= 0;
//         end
//     end
// end

always @(posedge clk) begin
    if (!resetn) begin
        trng_out <= 0;
        trng_word_reg <= 0;
        state <= 0;
        ready <= 0;
        cur_bit_ind <= 0;
    end else begin
        if (state == 0) begin
            ready <= 0;
            trng_word_reg <= 0;
            trng_out <= 0;
            cur_bit_ind <= 0;
            if (reg_read_sel) begin
                state <= 1;
            end
        end else if (state == 1) begin
            if (cur_bit_ind <= WIDTH-1) begin
                trng_word_reg<=(trng_word_reg<<1)+trng_bit;
                cur_bit_ind<=cur_bit_ind+1;
            end
            if (cur_bit_ind>=WIDTH-1) begin
                ready<=1;
                state <=0;
                trng_out<=1;
            end else begin 
                trng_out<=1;
                ready <=0;
            end
        end 
    end 
end 
assign trngio_ready = ready;
assign trngio_rdata = {(32-WIDTH)'h0, trng_word_reg};
assign trng_req = trng_out;

endmodule