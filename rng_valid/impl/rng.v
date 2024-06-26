module rng#(
    parameter OUTPUT_WIDTH = 8,
    parameter TRNG_WIDTH = 4
)(
	input clk,
    input reset,
    input en,

	input [TRNG_WIDTH-1:0] trng_word,
	input trng_valid,
	output trng_req,
	
	output [OUTPUT_WIDTH-1:0] random_word,
	output output_valid,
);

reg [OUTPUT_WIDTH-1:0] cur_word;
reg [5:0] cur_bit_ind;
reg is_valid;
reg want_next;
// reg [WIDTH-1:0] output_word;
reg reset_ind;
always @(posedge clk) begin
    if (reset) begin
        cur_word<=0;
        cur_bit_ind<=0;
        is_valid<=0;
        want_next <=0;
        reset_ind <=0;
    end
    else if (en) begin
    	if (cur_bit_ind <= 1) begin
    		if (trng_valid && want_next) begin
	    		cur_word<=(cur_word<<TRNG_WIDTH)+trng_word;
	    		// output_word<=(cur_word<<1)+trng_bit;
	    		cur_bit_ind<=cur_bit_ind+1;
    		end
    	end 
    	if (reset_ind) begin
    		cur_bit_ind<=0;
    		is_valid <=0;
    		want_next<=0;
    		cur_word<=0;
    		reset_ind<=0;
	    end else if (cur_bit_ind>1 || (cur_bit_ind==1 && trng_valid)) begin
	    	is_valid<=1;
	    	reset_ind <=1;
	    	want_next<=0;
	    end else begin 
	    	want_next<=1;
	    	is_valid <=0;
	    end
    end
end
assign trng_req=(en) ? want_next:0;
assign output_valid = (en) ? is_valid:0;
assign random_word = (en) ? ((is_valid) ? cur_word:0): 0;

endmodule