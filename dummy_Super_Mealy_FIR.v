module Super_Mealy_FIR
#(
	parameter nTap = 9,
	parameter super_ratio = 4 //,
) (
	input clock,
	input reset,
	input  [(32*super_ratio) - 1: 0] din,
	output [(32*super_ratio) - 1: 0] dout //,
);

reg  [(32*super_ratio) -1: 0] drin;
reg  [(32*(nTap-1) )   -1: 0] dst;

wire [(32*(nTap-1) )   -1: 0] stin [super_ratio:0];
wire [(32*(nTap-1) )   -1: 0] nst;


always @(posedge clock or posedge reset)
	if( reset ) {drin, dst} <= 
			{(32*super_ratio + 32*(nTap-1) ){1'b0}};
	else
			{ drin, dst } <= { din, nst };
// end (if, always)

assign stin[0] = dst;
assign nst = stin[super_ratio];

genvar i;
generate
for(i = 0; i < super_ratio; i = i + 1) begin: GLOOP

FIRCOMB STAGE #(9) (
	.clk(clock),
	.rst(reset),
	.din(drin[ 32*i+31 : 32*i ]),
	.pst(stin[ i ]),
	.nst(stin[ i+1 ]),
	.dout(dout[ 32*i+31 : 32*i ]) //,
);

end
endgenerate
 




endmodule
