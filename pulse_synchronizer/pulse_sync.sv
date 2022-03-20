module pulse_sync (
	// Asynchronous reset active low
	input 	logic rst_n,
	// Clock A interface
	input 	logic in_clk,
	input 	logic in_pulse,
	// Clock B interface
	input	logic out_clk,
	output	logic out_pulse
);

////////////////////////////////
// Declarations
////////////////////////////////

logic in_toggle_ff;

logic sync_out;
logic out_last_ff;

////////////////////////////////
// Logic
////////////////////////////////

always_ff @(posedge in_clk or negedge rst_n) begin : proc_in_toggle_ff
	if(~rst_n) begin
		in_toggle_ff <= 1'b0;
	end else begin
		// If receiving a new pulse
		if (in_pulse) begin
			// Toggle the FF
			in_toggle_ff <= ~in_toggle_ff;
		end
	end
end

// Standard dual FF synchronizer
dual_ff_sync #(.DATA_WIDTH(1)) dual_ff_sync_inst (
	.clk(out_clk),
	.rst_n(rst_n),
	.in_data(in_toggle_ff),
	.out_data(sync_out)
);

always_ff @(posedge in_clk or negedge rst_n) begin : proc_out_last_ff
	if(~rst_n) begin
		out_last_ff <= 1'b0;
	end else begin
		out_last_ff <= sync_out;
	end
end

// This detects changes in the toggle FF, and outputs the created pulse
assign out_pulse = out_last_ff ^^ sync_out;

endmodule : pulse_sync