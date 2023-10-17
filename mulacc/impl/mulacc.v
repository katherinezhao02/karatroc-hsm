module mulacc #(
    parameter WIDTH = 32
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
reg ovf;

always @(posedge clk) begin

    if (reset) begin
        acc = 1;
        extra = 0;
        ovf=0;
    end
    if (en) begin
        {extra, acc} = acc*x;
        ovf = (ovf > 0) ? 1: ((extra >32'b0) ? 1 : 0);
    end
    out =acc;
    
end
assign overflow = ovf;


endmodule