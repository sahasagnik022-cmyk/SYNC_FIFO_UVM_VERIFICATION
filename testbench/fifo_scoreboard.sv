`uvm_analysis_imp_decl (_wr)
`uvm_analysis_imp_decl (_rd)
`uvm_analysis_imp_decl (_out)
//Scoreboard
class fifo_scoreboard extends uvm_scoreboard;
`uvm_component_utils(fifo_scoreboard)
 uvm_analysis_imp_wr #(fifo_seq_item,fifo_scoreboard) wr_imp;
 uvm_analysis_imp_rd #(fifo_seq_item,fifo_scoreboard) rd_imp;
 uvm_analysis_imp_out #(fifo_seq_item,fifo_scoreboard) out_imp;

 bit[7:0] ref_q[$];
 bit[7:0] exp_q[$];
 int depth=256;
 int match=0;
 int mismatch=0;

//constructor
 function new(string name="fifo_scb",uvm_component parent=null);
    super.new(name,parent);
 endfunction
//build phase
 function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_imp=new("wr_imp",this);
    rd_imp=new("rd_imp",this);
    out_imp=new("out_imp",this);
 endfunction

//Write tx
 virtual function void write_wr(fifo_seq_item item);
    if(item.wr_en && item.wr_cs) begin
        if(!item.full) begin
            ref_q.push_back(item.data_in);
            `uvm_info("SCB_WR", $sformatf("Pushed %0h | Current Size: %0d | empty=%0d", item.data_in, ref_q.size(),item.empty), UVM_LOW)
        end else begin
            `uvm_info("SCB_WR", $sformatf("Write ignored Fifo full!! full=%0d",item.full), UVM_LOW);
        end
    end
 endfunction


 //Read Tx
 virtual function void write_rd(fifo_seq_item item);
    if(item.rd_en && item.rd_cs && !item.empty) begin
        if(ref_q.size()>0) begin
            bit [7:0] pdata=ref_q.pop_front();
            exp_q.push_back(pdata);
            `uvm_info("SCB_RD", $sformatf("Read data. Expecting to see %0h on the output next",pdata),UVM_LOW)
        end else begin
            `uvm_info("SCB_RD", $sformatf("Read ignored by ref model (FIFO Empty)!! empty=%0d",item.empty), UVM_LOW)
        end
    end
endfunction
//Output Mon Tx

virtual function void write_out(fifo_seq_item item);
    bit e_full;
    bit e_empty;

    e_full=(ref_q.size()==depth);
    e_empty=(ref_q.size()==0);
    if (item.full !== e_full) begin
        `uvm_error("SCB_FAIL", $sformatf("FULL flag mismatch! Expected: %0b, Actual: %0b", e_full, item.full))
    end
    else begin
        `uvm_info("SCB_PASS",$sformatf("Fifo full! Expected:%0b Actual:%0b",e_full,item.full),UVM_MEDIUM)
    end
    if (item.empty !== e_empty) begin
        `uvm_error("SCB_FAIL", $sformatf("EMPTY flag mismatch! Expected: %0b, Actual: %0b", e_empty, item.empty))
    end
    else begin
        `uvm_info("SCB_PASS",$sformatf("Fifo empty! Expected:%0b Actual:%0b",e_empty,item.empty),UVM_MEDIUM)
    end

    if(exp_q.size()>0) begin
        bit [7:0] edata=exp_q.pop_front();
        if (item.data_out !== edata) begin
            `uvm_error("SCB_FAIL", $sformatf("DATA mismatch! Expected: %0h, Actual: %0h, full=%0d", edata, item.data_out,item.full))
            mismatch++;     
        end else begin
            `uvm_info("SCB_PASS", $sformatf("DATA match! Expected: %0h, Actual: %0h, full=%0d", edata, item.data_out,item.full), UVM_MEDIUM)
            match++;
        end
    end
endfunction

 //Report phase
 function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    // UVM_NONE ensures this always prints at the end of the simulation
    `uvm_info("[SCB_RESULTS]", "=======================================", UVM_NONE)
    `uvm_info("[SCB_RESULTS]", $sformatf(" TOTAL MATCHES    : %0d", match), UVM_NONE)
    `uvm_info("[SCB_RESULTS]", $sformatf(" TOTAL MISMATCHES : %0d", mismatch), UVM_NONE)
    `uvm_info("[SCB_RESULTS]", "=======================================", UVM_NONE)
 endfunction

endclass
