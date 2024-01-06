module rng#(
    parameter WIDTH = 4
)(
	input clk,
    input reset,
    input en,

	input trng_bit,
	output trng_next,
	
	input req,
	output [WIDTH-1:0] random_word,
	output output_valid,
);

reg [WIDTH-1:0] cur_word;
reg [5:0] cur_bit_ind;
reg valid;
reg want_next;
always @(posedge clk) begin
    if (reset) begin
        cur_word<=0;
        cur_bit_ind<=0;
        valid<=0;
        want_next <=1;
    end
    else if (en) begin
    	if (cur_bit_ind <= WIDTH-1) begin
	    	cur_word<=(cur_word<<1)+trng_bit;
	    	cur_bit_ind<=cur_bit_ind+1;
    	end
	    if (req && cur_bit_ind>=WIDTH-1) begin
	    	valid<=1;
	    	cur_bit_ind <=0;
	    	want_next<=1;
	    end else if (cur_bit_ind>=WIDTH-1) begin
	    	valid <=0;
	    	want_next<=0;
	    end else begin 
	    	want_next<=1;
	    	valid <=0;
	    end
    end
end
assign trng_next=want_next;
assign random_word=cur_word;
assign output_valid = valid;
endmodule