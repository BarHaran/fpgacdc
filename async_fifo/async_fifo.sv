module async_fifo #(
	parameter int DATA_WIDTH = 4,
	parameter int ADDR_WIDTH = 8
)(
	// Asynchronous reset active low
	input 	logic rst_n,
	// Write interface
	input 	logic wr_clk,
	input 	logic [DATA_WIDTH-1:0]	wr_data,
	input	logic wr_en,
	output	logic wr_full,
	// Clock B interface
	input	logic rd_clk,
	output	logic [DATA_WIDTH-1:0]	rd_data,
	input	logic rd_en,
	output	logic rd_empty
);

	logic [ADDR_WIDTH-1:0] wr_ptr;
	logic [ADDR_WIDTH-1:0] sync_wr_ptr;
	logic [ADDR_WIDTH-1:0] rd_ptr;
	logic [ADDR_WIDTH-1:0] sync_rd_ptr;

	sdpram #(
		.DATA_WIDTH(DATA_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH)
	) i_sdpram (
		.wr_clk  (wr_clk  ),
		.rd_clk  (rd_clk  ),
		.d       (wr_data),
		.q       (rd_data),
		.addr_in (wr_ptr),
		.addr_out(rd_ptr),
		.wr_en   (wr_en && ~wr_full)
	);

	always_ff @(posedge wr_clk or negedge rst_n) begin : proc_wr_ptr
		if(~rst_n) begin
			wr_ptr <= {ADDR_WIDTH{1'b0}};
		end else begin
			if (wr_en && ~wr_full) begin
				wr_ptr <= wr_ptr + 1'b1;
			end
		end
	end

	always_ff @(posedge rd_clk or negedge rst_n) begin : proc_rd_ptr
		if(~rst_n) begin
			rd_ptr <= {ADDR_WIDTH{1'b0}};
		end else begin
			if (rd_en && ~rd_empty) begin
				rd_ptr <= rd_ptr + 1'b1;
			end
		end
	end

	dual_ff_sync #(.DATA_WIDTH(ADDR_WIDTH)) sync_wr_ptr_inst (
		.clk     (rd_clk  ),
		.rst_n   (rst_n   ),
		.in_data (wr_ptr ),
		.out_data(sync_wr_ptr)
	);

	dual_ff_sync #(.DATA_WIDTH(ADDR_WIDTH)) sync_rd_ptr_inst (
		.clk     (wr_clk  ),
		.rst_n   (rst_n   ),
		.in_data (rd_ptr ),
		.out_data(sync_rd_ptr)
	);

	assign wr_full	= (wr_ptr[ADDR_WIDTH-2:0] == sync_rd_ptr[ADDR_WIDTH-2:0]) && (wr_ptr[ADDR_WIDTH-1] == ~sync_rd_ptr[ADDR_WIDTH-1]);
	assign rd_empty	= (rd_ptr == sync_rd_ptr);

endmodule : async_fifo