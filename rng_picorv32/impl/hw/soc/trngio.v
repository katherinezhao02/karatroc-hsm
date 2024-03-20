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

// layout:
// ADDR -- GPIO write req register
//   +4 -- GPIO read word, valid register

wire reg_write_sel = mem_valid && (mem_addr == ADDR);
wire reg_read_sel = mem_valid && (mem_addr == (ADDR + 4));
assign trngio_sel = reg_read_sel || reg_write_sel;


// state 0: not requested yet, state 1: requested but not valid, state 2: got data but has not read into picorv32
reg [2:0] state; 
reg ready;

// read logic
reg [TRNG_WIDTH-1:0] trng_word_reg;
// reg trng_word_valid;

// write logic
reg trng_out;

always @(posedge clk) begin
    if (!resetn) begin
        trng_out <= 0;
        trng_word_reg <= 0;
        state <= 0;
        ready <= 0;
    end else 
        if (state ==0) begin
            ready <= 1;
            trng_word_reg <= 0;
            if (reg_write_sel && mem_wstrb[0]) begin // If the picorv requests, then we also request to trng until we get valid
                if (mem_wdata[0]) begin
                    trng_out <= 1;
                    state <= 1;
                    ready <= 0; // Don't accept any more reads/writes until we get the next word from trng
                end
            end
        end else if (state == 1) begin
            ready <= 0;
            if (trng_valid) begin
                trng_out <= 0; // Don't want to request anymore
                trng_word_reg <= trng_word; // Store the random word until we get a read request
                ready <= 1;
                state <= 2;
            end
        end else if (state == 2) begin
            ready <= 1;
            if (reg_read_sel) begin
                state <= 0;
            end
        end
    end
end
assign trngio_ready = ready;
assign trngio_rdata = {(32-TRNG_WIDTH)'h0, trng_word_reg};
assign trng_req = trng_out;

endmodule