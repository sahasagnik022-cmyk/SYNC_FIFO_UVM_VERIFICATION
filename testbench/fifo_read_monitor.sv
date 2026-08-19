class fifo_read_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_read_monitor)
    uvm_analysis_port #(fifo_seq_item) read_mon_port;
    virtual fifo_if vif;
    function new(string name="fifo_read_monitor",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        read_mon_port=new("read_mon_port",this);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("RD_MON", "Could not get virtual interface vif from config DB!")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        fifo_seq_item item;
        wait(!vif.rst);

        forever begin
            @(vif.rd_mon_cb);
       //     if (vif.rd_mon_cb.rd_en && vif.rd_mon_cb.rd_cs) begin
                item = fifo_seq_item::type_id::create("item");
                item.rd_en = vif.rd_mon_cb.rd_en;
                item.rd_cs = vif.rd_mon_cb.rd_cs;
                item.full=vif.rd_mon_cb.full;
                item.empty=vif.rd_mon_cb.empty;
                read_mon_port.write(item);
       //     end
        end
    endtask

endclass
