module ack_if_sync #(
	parameter int DATA_WIDTH = 4
)(
	// Asynchronous reset active low
	input 	logic rst_n,
	// Clock A interface
	input 	logic source_clk,
	input 	logic [DATA_WIDTH-1:0]	source_data,
	input	logic source_valid,
	output	logic source_ack,
	// Clock B interface
	input	logic sink_clk,
	output	logic [DATA_WIDTH-1:0]	sink_data,
	output	logic sink_valid,
	input	logic sink_ack
);


////////////////////////////////
// Declarations
////////////////////////////////

logic [DATA_WIDTH-1:0] valid_data;

////////////////////////////////
// Logic
////////////////////////////////

always_ff @(posedge source_clk or negedge rst_n) begin : proc_valid_data
	if(~rst_n) begin
		valid_data <= {DATA_WIDTH{1'b0}};
	end else begin
		if (source_valid) begin
			valid_data <= source_data;
		end
	end
end

pulse_sync valid_sync_inst (
	.rst_n    (rst_n    ),
	.in_clk   (source_clk),
	.in_pulse (source_valid),
	.out_clk  (sink_clk),
	.out_pulse(sink_valid)
);

dual_ff_sync #(
	.DATA_WIDTH(DATA_WIDTH)
) data_sync_inst (
	.clk     (sink_clk),
	.rst_n   (rst_n     ),
	.in_data (valid_data   ),
	.out_data(sink_data  )
);

pulse_sync ack_sync_inst (
	.rst_n    (rst_n),
	.in_clk(sink_clk),
	.in_pulse(sink_ack),
	.out_clk(source_clk),
	.out_pulse(source_ack)
);

endmodule : ack_if_sync