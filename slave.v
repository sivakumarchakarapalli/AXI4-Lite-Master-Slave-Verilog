`timescale 1ns/1ps
module axi4( 
    input wire clk,
    input wire reset,

    // AW
    input wire awvalid,
    input wire [31:0] awaddr,
    output reg awready,
    
    // W
    input wire wvalid,
    input wire [31:0] wdata,
    output reg wready,

    // B
    output reg bvalid,
    output reg [1:0] bresp,
    input wire bready,

    // AR
    input wire arvalid,
    input wire [31:0] araddr,
    output reg arready,

    // R
    output reg [31:0] rdata,
    output reg rvalid,
    output reg [1:0] rresp,
    input wire rready
);

    reg [31:0] my_reg [0:31];
    reg aw_handshake, w_handshake, ar_handshake;
    reg [4:0] aw_index, ar_index;

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            awready <= 0;
            wready  <= 0;
            bvalid  <= 0;
            bresp   <= 2'b00;
            arready <= 0;
            rvalid  <= 0;
            rresp   <= 2'b00;
            rdata   <= 0;

            aw_handshake <= 0;
            w_handshake  <= 0;
            ar_handshake <= 0;

            for (i = 0; i < 32; i = i + 1)
                my_reg[i] <= 32'd0;
        end else begin
            // defaults
            awready <= 0;
            wready  <= 0;
            arready <= 0;

            // AW channel
            if (awvalid && !aw_handshake) begin
                awready <= 1;
                aw_handshake <= 1;
                aw_index <= awaddr[6:2];
            end

            // W channel
            if (wvalid && !w_handshake) begin
                wready <= 1;
                w_handshake <= 1;
            end

            // Write
            if (aw_handshake && w_handshake && !bvalid) begin
                my_reg[aw_index] <= wdata;
                bvalid <= 1;
                bresp  <= 2'b00;
            end

            if (bvalid && bready) begin
                bvalid <= 0;
                aw_handshake <= 0;
                w_handshake  <= 0;
            end

            // AR channel
            if (arvalid && !ar_handshake) begin
                arready <= 1;
                ar_handshake <= 1;
                ar_index <= araddr[6:2];
            end

            // R channel
            if (ar_handshake && !rvalid) begin
                rdata  <= my_reg[ar_index];
                rvalid <= 1;
                rresp  <= 2'b00;
            end

            if (rvalid && rready) begin
                rvalid <= 0;
                ar_handshake <= 0;
            end
        end
    end
endmodule
