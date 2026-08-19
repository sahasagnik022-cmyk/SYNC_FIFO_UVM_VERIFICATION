class fifo_virtual_sequencer extends uvm_sequencer;
    `uvm_component_utils(fifo_virtual_sequencer)
    fifo_seqr w_seqr;
    fifo_seqr r_seqr;
    function new(string name = "fifo_virtual_sequencer", uvm_component parent=null);
        super.new(name, parent);    
    endfunction
endclass
