class fifo_output_agent extends uvm_agent;
    `uvm_component_utils(fifo_output_agent)
    fifo_output_monitor out_mon;
    function new(string name = "fifo_output_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        out_mon = fifo_output_monitor::type_id::create("out_mon", this);
    endfunction
endclass
