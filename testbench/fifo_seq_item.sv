class fifo_seq_item extends uvm_sequence_item;
    `uvm_object_utils(fifo_seq_item)
    rand bit[7:0] data_in;
    rand bit wr_cs,wr_en;
    rand bit rd_cs,rd_en;
    bit [7:0] data_out;
    bit full,empty;

    function new(string name="fifo_seq_item");
        super.new(name);
    endfunction
endclass
