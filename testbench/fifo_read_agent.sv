class fifo_read_agent extends uvm_agent;
    `uvm_component_utils(fifo_read_agent)
    fifo_seqr r_seqr;
    fifo_read_driver r_drv;
    fifo_read_monitor r_mon;

    function new(string name="fifo_read_agent",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        r_mon=fifo_read_monitor::type_id::create("r_mon",this);
        if(get_is_active()== UVM_ACTIVE) begin
            r_seqr=fifo_seqr::type_id::create("r_seqr",this);
            r_drv=fifo_read_driver::type_id::create("r_drv",this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(get_is_active()==UVM_ACTIVE)
        r_drv.seq_item_port.connect(r_seqr.seq_item_export);
    endfunction
endclass
