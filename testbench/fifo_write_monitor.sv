class fifo_write_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_write_monitor)
    uvm_analysis_port #(fifo_seq_item) write_mon_port;
    virtual fifo_if vif;
    function new(string name="fifo_write_monitor",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        write_mon_port=new("write_mon_port",this);
        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) 
        `uvm_fatal("WR_MON", "Could not get virtual interface vif from config DB!")
    endfunction

    virtual task run_phase(uvm_phase phase);
        fifo_seq_item item;
        wait(!vif.rst);
        forever begin
            @(vif.wr_mon_cb);
     //       if(vif.wr_mon_cb.wr_en && vif.wr_mon_cb.wr_cs) begin
                item=fifo_seq_item::type_id::create("item");
                item.wr_cs=vif.wr_mon_cb.wr_cs;
                item.wr_en=vif.wr_mon_cb.wr_en;
                item.data_in=vif.wr_mon_cb.data_in;
                item.full=vif.wr_mon_cb.full;
                item.empty=vif.wr_mon_cb.empty;
                write_mon_port.write(item);
         //   end
        end
    endtask
endclass
