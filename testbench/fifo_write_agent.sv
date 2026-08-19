class fifo_write_agent extends uvm_agent;
    `uvm_component_utils(fifo_write_agent)
    fifo_seqr w_seqr;
    fifo_write_driver w_drv;
    fifo_write_monitor w_mon;

    function new(string name="fifo_write_agent",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        w_mon=fifo_write_monitor::type_id::create("w_mon",this);
        if(get_is_active()== UVM_ACTIVE) begin
            w_seqr=fifo_seqr::type_id::create("w_seqr",this);
            w_drv=fifo_write_driver::type_id::create("w_drv",this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(get_is_active()==UVM_ACTIVE)
        w_drv.seq_item_port.connect(w_seqr.seq_item_export);
    endfunction
endclass
