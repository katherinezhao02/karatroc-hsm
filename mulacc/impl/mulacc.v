module mulacc #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input en,
    input [WIDTH-1:0] x,
    output reg [WIDTH-1:0] out,
    output overflow
);

reg [WIDTH-1:0] acc;
reg [WIDTH-1:0] extra;
reg [WIDTH-1:0] tmp_acc;
reg state;
reg ovf;

always @(posedge clk) begin

    if (reset) begin
        extra <= 0;
        out<=1;
        state<=0;
    end
    else if (en) begin
        if (state ==0) begin
            {extra, tmp_acc} <= acc*x;
            state <=1;
        end else begin
            ovf <= (ovf > 0) ? 1: ((extra >0) ? 1 : 0);
            acc <= tmp_acc;
            state<=0;
        end
    end
    out <=acc;
    
end
assign overflow = ovf;


endmodule