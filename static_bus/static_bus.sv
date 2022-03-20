module static_bus #(
	parameter int DATA_WIDTH = 4
)(
	// Asynchronous reset active low
	input 	logic rst_n,
	// Clock A interface
	input 	logic in_clk,
	input 	logic [DATA_WIDTH-1:0]	in_data,
	// Clock B interface
	input	logic out_clk,
	output	logic [DATA_WIDTH-1:0]	out_data
);


////////////////////////////////
// Declarations
////////////////////////////////

logic [DATA_WIDTH-1:0] in_synchronizer;
logic [DATA_WIDTH-1:0] out_first_flop;

////////////////////////////////
// Logic
////////////////////////////////

// Clock A's FF
always_ff @(posedge in_clk or negedge rst_n) begin : proc_in_sync
	if(~rst_n) begin
		in_synchronizer <= {DATA_WIDTH{1'b0}};
	end else begin
		in_synchronizer <= in_data;
	end
end

// Clock B's dual FF synchronizer
dual_ff_sync #(.DATA_WIDTH(DATA_WIDTH)) dual_ff_sync_inst (
	.rst_n(rst_n),
	.clk(out_clk),
	.in_data(in_synchronizer),
	.out_data(out_data)
);

endmodule : static_bus