class fifo_write_sequence extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_write_sequence)
    function new(string name = "fifo_write_sequence");
        super.new(name);
    endfunction
    virtual task body();
        req=fifo_seq_item::type_id::create("req");
        start_item(req);
        if(!req.randomize() with { wr_cs == 0; wr_en == 0; rd_cs == 0; rd_en == 0; })
            `uvm_error("SEQ_WR", "Randomization failed!")
        finish_item(req);
        req=fifo_seq_item::type_id::create("req");
        start_item(req);
        if(!req.randomize() with { wr_cs == 1; wr_en == 0; rd_cs == 0; rd_en == 0; })
            `uvm_error("SEQ_WR", "Randomization failed!")
        finish_item(req);
        req=fifo_seq_item::type_id::create("req");
        start_item(req);
        if(!req.randomize() with { wr_cs == 0; wr_en == 1; rd_cs == 0; rd_en == 0; })
            `uvm_error("SEQ_WR", "Randomization failed!")
        finish_item(req);
        for (int i = 0; i < 260; i++) begin
            req = fifo_seq_item::type_id::create("req");
            start_item(req);
            if (!req.randomize() with { wr_en == 1; wr_cs == 1;rd_cs ==0;rd_en==0; }) begin
                `uvm_error("SEQ_WR", "Randomization failed!")
            end
            finish_item(req);
        end
    endtask
endclass 
