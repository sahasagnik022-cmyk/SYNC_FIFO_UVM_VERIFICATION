class fifo_reset_read_sequence extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_reset_read_sequence)
    
    function new(string name = "fifo_reset_read_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        `uvm_info("SEQ_RST", "Starting Reset Verification Sequence...", UVM_LOW)

        // ---------------------------------------------------------
        // STEP 1: Immediate Read Request
        // Proves empty=1, full=0, and data_out defaults to 0
        // ---------------------------------------------------------
        req = fifo_seq_item::type_id::create("req");
        start_item(req);
        if(!req.randomize() with { rd_cs == 1; rd_en == 1; wr_cs == 0; wr_en == 0; }) begin
            `uvm_error("SEQ_RST", "Randomization failed!")
        end
        finish_item(req);

        // ---------------------------------------------------------
        // STEP 2: Idle Transaction
        // Gives the output monitor 1 extra clock cycle to sample 
        // the final data_out state safely.
        // ---------------------------------------------------------
        req = fifo_seq_item::type_id::create("req");
        start_item(req);
        if(!req.randomize() with { rd_cs == 0; rd_en == 0; wr_cs == 0; wr_en == 0; }) begin
            `uvm_error("SEQ_RST", "Randomization failed!")
        end
        finish_item(req);
        
        `uvm_info("SEQ_RST", "Reset Verification Sequence Complete!", UVM_LOW)
    endtask
endclass
