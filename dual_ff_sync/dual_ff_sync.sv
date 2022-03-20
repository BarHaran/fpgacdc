module dual_ff_sync #(
	parameter int DATA_WIDTH = 4
)(
	input	logic clk,
	input	logic rst_n,
	
	input	logic [DATA_WIDTH-1:0]	in_data,
	output	logic [DATA_WIDTH-1:0]	out_data
);

////////////////////////////////
// Declarations
////////////////////////////////

logic [DATA_WIDTH-1:0] first_sample;

////////////////////////////////
// Logic
////////////////////////////////

always_ff @(posedge clk or negedge rst_n) begin : proc_synchronizer
	if(~rst_n) begin
		first_sample	<= {DATA_WIDTH{1'b0}};
		out_data		<= {DATA_WIDTH{1'b0}};
	end else begin
		first_sample	<= in_data;
		out_data		<= first_sample;
	end
end

endmodule : dual_ff_sync