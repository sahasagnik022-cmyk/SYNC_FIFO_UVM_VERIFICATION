`timescale 1ns/1ps

interface fifo_if(input bit clk,rst);
    logic [7:0] data_in;
    logic [7:0] data_out;
    logic empty;
    logic full;
    logic rd_en;
    logic wr_en;
    logic wr_cs;
    logic rd_cs;
    clocking wr_drv_cb@(posedge clk);
        default input #1 output #0;
        output data_in;
        output wr_en;
        output wr_cs;
        input full,empty; //To inspect full and empty flag
    endclocking

    clocking rd_drv_cb@(posedge clk);
        default input #1 output #0;
        output rd_en;
        output rd_cs;
        input full,empty; //To inspect full and empty flag
    endclocking


    clocking wr_mon_cb@(posedge clk);
        default input #1 output #0;
        input data_in;
        input wr_en;
        input wr_cs;
        input full;
        input empty;
    endclocking

    clocking rd_mon_cb@(posedge clk);
        default input #1 output #0;
        input rd_en;
        input rd_cs;
        input full;
        input empty;
    endclocking

    clocking out_mon_cb@(posedge clk);
        default input #1 output #1;
        input data_out,data_in,empty,full,rd_en,wr_en,rd_cs,wr_cs;
    endclocking

    modport wr_drv(clocking wr_drv_cb,input clk,rst);
    modport rd_drv(clocking rd_drv_cb,input clk,rst);
    modport wr_mon(clocking wr_mon_cb,input clk,rst);
    modport rd_mon(clocking rd_mon_cb,input clk,rst);
    modport out_mon(clocking out_mon_cb,input clk,rst);
property p_full_empty;
        @(posedge clk) disable iff (rst)
        !(full && empty);
endproperty

assert_fe: assert property(p_full_empty)
else begin
    $fatal(1, "SVA FAILURE: FIFO reported full=1 and empty=1 simultaneously at time %0t!", $time);
end
endinterface
