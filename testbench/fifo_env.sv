class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)
    fifo_write_agent w_agt;
    fifo_read_agent r_agt;
    fifo_output_agent o_agt;
    fifo_scoreboard scb;
    fifo_subscriber sub;
    fifo_virtual_sequencer v_seqr;

    function new(string name="fifo_env",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        w_agt=fifo_write_agent::type_id::create("w_agt",this);
        r_agt=fifo_read_agent::type_id::create("r_agt", this);
        o_agt=fifo_output_agent::type_id::create("o_agt", this);
        v_seqr=fifo_virtual_sequencer::type_id::create("v_seqr",this);
        scb = fifo_scoreboard::type_id::create("scb", this);
        sub = fifo_subscriber::type_id::create("sub", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        v_seqr.w_seqr = w_agt.w_seqr;
        v_seqr.r_seqr = r_agt.r_seqr;
        w_agt.w_mon.write_mon_port.connect(scb.wr_imp);
        w_agt.w_mon.write_mon_port.connect(sub.analysis_export);
        r_agt.r_mon.read_mon_port.connect(scb.rd_imp);
        r_agt.r_mon.read_mon_port.connect(sub.r_exp);
        o_agt.out_mon.out_mon_port.connect(scb.out_imp);
    endfunction

endclass
