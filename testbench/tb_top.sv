`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;
import fifo_pkg::*; 

module tb_top();
    bit clk;
    bit rst;
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        #12;
        rst = 0;
    end

    fifo_if vif(clk, rst);

    syn_fifo DUV (
        .clk(clk),
        .rst(rst),
        .wr_cs(vif.wr_cs),
        .wr_en(vif.wr_en),
        .rd_cs(vif.rd_cs),
        .rd_en(vif.rd_en),
        .data_in(vif.data_in),
        .data_out(vif.data_out),
        .full(vif.full),
        .empty(vif.empty)
    );

    initial begin
        uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", vif);
        run_test("fifo_test");
    end

endmodule
