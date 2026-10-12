module top (
    input clk,
    input reset,
    input wr_en,
    input rd_en,
    input [31:0] addr,
    input [31:0] wdata_in,
    output [31:0] rdata_out,
    output read_done,
    output write_done
);

    wire awvalid, awready;
    wire wvalid, wready;
    wire bvalid, bready;
    wire arvalid, arready;
    wire rvalid, rready;
    wire [31:0] awaddr, araddr, wdata, rdata;

    master m (
        .clk(clk), .reset(reset),
        .wr_en(wr_en), .rd_en(rd_en),
        .addr(addr), .wdata_in(wdata_in),
        .rdata_out(rdata_out),
        .read_done(read_done),
        .write_done(write_done),
        .awvalid(awvalid), .awaddr(awaddr), .awready(awready),
        .wvalid(wvalid), .wdata(wdata), .wready(wready),
        .bvalid(bvalid), .bready(bready),
        .arvalid(arvalid), .araddr(araddr), .arready(arready),
        .rvalid(rvalid), .rready(rready), .rdata(rdata)
    );

    axi4 s (
        .clk(clk), .reset(reset),
        .awvalid(awvalid), .awaddr(awaddr), .awready(awready),
        .wvalid(wvalid), .wdata(wdata), .wready(wready),
        .bvalid(bvalid), .bready(bready),
        .arvalid(arvalid), .araddr(araddr), .arready(arready),
        .rvalid(rvalid), .rready(rready), .rdata(rdata)
    );
endmodule
