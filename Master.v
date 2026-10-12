`timescale 1ns/1ps
module master(
    input clk,
    input reset,
    input wr_en,
    input rd_en,
    input [31:0] addr,
    input [31:0] wdata_in,

    output reg [31:0] rdata_out,
    output reg read_done,
    output reg write_done,

    // AXI Write Address
    output reg awvalid,
    output reg [31:0] awaddr,
    input awready,

    // AXI Write Data
    output reg wvalid,
    output reg [31:0] wdata,
    input wready,

    // AXI Write Response
    input bvalid,
    output reg bready,

    // AXI Read Address
    output reg arvalid,
    output reg [31:0] araddr,
    input arready,

    // AXI Read Data
    output reg rready,
    input [31:0] rdata,
    input rvalid
);

    // FSM states
    parameter W_IDLE = 2'd0,
              W_AW   = 2'd1,
              W_W    = 2'd2,
              W_B    = 2'd3;

    parameter R_IDLE = 2'd0,
              R_AR   = 2'd1,
              R_R    = 2'd2;

    reg [1:0] w_state;
    reg [1:0] r_state;

    // -------------------------------------------------
    // SEQUENTIAL LOGIC
    // -------------------------------------------------
    always @(posedge clk) begin
        if (reset) begin
            // Reset outputs
            awvalid <= 0;
            wvalid  <= 0;
            bready  <= 0;
            arvalid <= 0;
            rready  <= 0;

            write_done <= 0;
            read_done  <= 0;
            rdata_out  <= 32'd0;

            w_state <= W_IDLE;
            r_state <= R_IDLE;
        end else begin
            // -------------------------
            // DEFAULTS (CRITICAL FIX)
            // -------------------------
            awvalid <= 0;
            wvalid  <= 0;
            bready  <= 0;
            arvalid <= 0;
            rready  <= 0;
            write_done <= 0;
            read_done  <= 0;

            // =========================
            // WRITE FSM
            // =========================
            case (w_state)
                W_IDLE: begin
                    if (wr_en) begin
                        awaddr <= addr;
                        wdata  <= wdata_in;
                        w_state <= W_AW;
                    end
                end

                W_AW: begin
                    awvalid <= 1;
                    if (awready)
                        w_state <= W_W;
                end

                W_W: begin
                    wvalid <= 1;
                    if (wready)
                        w_state <= W_B;
                end

                W_B: begin
                    bready <= 1;
                    if (bvalid) begin
                        write_done <= 1;
                        w_state <= W_IDLE;
                    end
                end
            endcase

            // =========================
            // READ FSM  (FIXED)
            // =========================
            case (r_state)
                R_IDLE: begin
                    if (rd_en) begin
                        araddr <= addr;
                        r_state <= R_AR;
                    end
                end

                R_AR: begin
                    arvalid <= 1;
                    if (arready)
                        r_state <= R_R;
                end

                R_R: begin
                    rready <= 1;   // ASSERT READY
                    if (rvalid && rready) begin
                        rdata_out <= rdata;  // SAFE SAMPLING
                        read_done <= 1;
                        r_state <= R_IDLE;
                    end
                end
            endcase
        end
    end
endmodule
