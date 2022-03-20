module sdpram #(
	parameter int DATA_WIDTH = 4,
	parameter int ADDR_WIDTH = 8
)(
	input	logic wr_clk,
	input	logic rd_clk,
	input	logic [DATA_WIDTH-1:0]	d,
	output	logic [DATA_WIDTH-1:0]	q,
	input	logic [ADDR_WIDTH-1:0]	addr_in,
	input	logic [ADDR_WIDTH-1:0]	addr_out,
	input	logic wr_en
);

	localparam int RAM_DEPTH = 2 ** ADDR_WIDTH;

	reg [ADDR_WIDTH-1:0] addr_out_reg;
	reg [DATA_WIDTH-1:0] mem [RAM_DEPTH-1:0];
 
	always @(posedge wr_clk) begin
		if (wr_en)
			mem[addr_in] <= d;
	end
 
 	// Read latency 2
	/*always @(posedge rd_clk) begin
		q <= mem[addr_out_reg];
		addr_out_reg <= addr_out;
	end*/

	// Read latency 1
	always @(posedge rd_clk) begin
		q <= mem[addr_out];
	end

endmodule : sdpram