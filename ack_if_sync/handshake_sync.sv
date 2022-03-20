module handshake_sync #(
	parameter int DATA_WIDTH = 4
)(
	// Asynchronous reset active low
	input 	logic rst_n,
	// Clock A interface
	input 	logic source_clk,
	input 	logic [DATA_WIDTH-1:0]	source_data,
	input	logic source_valid,
	output	logic source_ready,
	// Clock B interface
	input	logic sink_clk,
	output	logic [DATA_WIDTH-1:0]	sink_data
);


////////////////////////////////
// Declarations
////////////////////////////////

logic source_send;
logic source_ack;

logic sink_send;

logic [DATA_WIDTH-1:0] source_synced_data;

logic [DATA_WIDTH-1:0] sink_synced_data;

////////////////////////////////
// Logic
////////////////////////////////

assign source_send = source_ready && source_valid;

pulse_sync send_sync_inst (
	.rst_n    (rst_n    ),
	.in_clk   (source_clk),
	.in_pulse (source_send),
	.out_clk  (sink_clk),
	.out_pulse(sink_send)
);

always_ff @(posedge source_clk or negedge rst_n) begin : proc_source_data
	if(~rst_n) begin
		source_synced_data <= {DATA_WIDTH{1'b0}};
	end else begin
		if (source_send) begin
			source_synced_data <= source_data;
		end
	end
end

dual_ff_sync #(.DATA_WIDTH(DATA_WIDTH)) i_dual_ff_sync (
	.clk     (sink_clk),
	.rst_n   (rst_n     ),
	.in_data (source_synced_data),
	.out_data(sink_synced_data)
);

always_ff @(posedge sink_clk or negedge rst_n) begin : proc_sink_data
	if(~rst_n) begin
		sink_data <= {DATA_WIDTH{1'b0}};
	end else begin
		if (sink_send) begin
			sink_data	<= sink_synced_data;
		end
	end
end

pulse_sync ack_sync_inst (
	.rst_n    (rst_n),
	.in_clk(sink_clk),
	.in_pulse(sink_send),
	.out_clk(source_clk),
	.out_pulse(source_ack)
);

always_ff @(posedge source_clk or negedge rst_n) begin : proc_source_ready
	if(~rst_n) begin
		source_ready <= 1'b1;
	end else begin
		if (source_send) begin
			source_ready <= 1'b0;
		end
		if (source_ack) begin
			source_ready <= 1'b1;
		end
	end
end

endmodule : handshake_sync