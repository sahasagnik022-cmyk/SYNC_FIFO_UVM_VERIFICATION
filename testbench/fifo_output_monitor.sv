class fifo_output_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_output_monitor)
    uvm_analysis_port#(fifo_seq_item) out_mon_port;
    virtual fifo_if vif;

    function new(string name="fifo_output_monitor",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        out_mon_port=new("out_mon_port",this);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("OUT_MON", "Could not get virtual interface vif from config DB!")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        fifo_seq_item item;
        wait(!vif.rst);
        forever begin
            @(vif.out_mon_cb);
            if(vif.out_mon_cb.rd_en) begin
                @(vif.out_mon_cb);
                item=fifo_seq_item::type_id::create("item");
                item.data_out=vif.out_mon_cb.data_out;
                item.full=vif.out_mon_cb.full;
                item.empty=vif.out_mon_cb.empty;
                out_mon_port.write(item);
            end
        end
    endtask
endclass
