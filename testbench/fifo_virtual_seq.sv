class fifo_virtual_seq extends uvm_sequence;
    `uvm_object_utils(fifo_virtual_seq)
    fifo_reset_read_sequence re_seq;
    fifo_read_short_sequence rd_seq;
    fifo_read_sequence  r_seq;
    fifo_write_sequence w_seq;
    
    `uvm_declare_p_sequencer(fifo_virtual_sequencer)
    
    function new(string name = "fifo_virtual_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        re_seq=fifo_reset_read_sequence::type_id::create("re_seq");
        rd_seq=fifo_read_short_sequence::type_id::create("rd_seq");
        r_seq = fifo_read_sequence::type_id::create("r_seq");
        w_seq = fifo_write_sequence::type_id::create("w_seq");
        re_seq.start(p_sequencer.r_seqr);
        w_seq.start(p_sequencer.w_seqr); 
        r_seq.start(p_sequencer.r_seqr);
        w_seq.start(p_sequencer.w_seqr); 
        rd_seq.start(p_sequencer.r_seqr);
    endtask
endclass
