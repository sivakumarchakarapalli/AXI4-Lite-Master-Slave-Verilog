`timescale 1ns/1ps

module tb_top;

    // DUT inputs
    reg clk;
    reg reset;
    reg wr_en;
    reg rd_en;
    reg [31:0] addr;
    reg [31:0] wdata_in;

    // DUT outputs
    wire [31:0] rdata_out;
    wire read_done;
    wire write_done;

    // Instantiate TOP (DUT)
    top dut (
        .clk(clk),
        .reset(reset),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .addr(addr),
        .wdata_in(wdata_in),
        .rdata_out(rdata_out),
        .read_done(read_done),
        .write_done(write_done)
    );

    // CLOCK: 10 ns period
    always #5 clk = ~clk;

    // TEST SEQUENCE
    initial begin
        // Initial values
        clk = 0;
        reset = 1;
        wr_en = 0;
        rd_en = 0;
        addr = 0;
        wdata_in = 0;

        // Apply reset
        #20;
        reset = 0;

        // WRITE TRANSACTION

        @(posedge clk);
        addr = 32'h0000_0004;     // register index = 1
        wdata_in = 32'hA5A5_1234;
        wr_en = 1;

        @(posedge clk);
        wr_en = 0;

        // Wait for write completion
        wait (write_done == 1);
        $display("[%0t] WRITE DONE", $time);


        // READ TRANSACTION

        @(posedge clk);
        addr = 32'h0000_0004;     // same address
        rd_en = 1;

        @(posedge clk);
        rd_en = 0;

        // Wait for read completion
        wait (read_done == 1);
        $display("[%0t] READ DONE", $time);
        $display("READ DATA = %h", rdata_out);

        // CHECK RESULT
        if (rdata_out == wdata_in)
            $display(" TEST PASSED");
        else
            $display(" TEST FAILED");

        #20;
        $finish;
    end

endmodule
