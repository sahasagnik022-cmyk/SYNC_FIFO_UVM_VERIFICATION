class fifo_read_driver extends uvm_driver #(fifo_seq_item);
    `uvm_component_utils(fifo_read_driver);
    virtual fifo_if vif;
    function new(string name="fifo_read_driver",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal("RD_DRV", "Could not get virtual interface vif from config DB!")
    endfunction

    virtual task run_phase(uvm_phase phase);
        @(vif.rd_drv_cb);
        vif.rd_drv_cb.rd_en <= 1'b0;
        vif.rd_drv_cb.rd_cs <= 1'b0;
        wait(!vif.rst);
        forever begin
            seq_item_port.get_next_item(req);
            drive_item(req);
            seq_item_port.item_done();
            @(vif.rd_drv_cb);
            vif.rd_drv_cb.rd_en <= 0;
            vif.rd_drv_cb.rd_cs <= 0;
        end
    endtask

    virtual task drive_item(fifo_seq_item item);
        @(vif.rd_drv_cb);
        vif.rd_drv_cb.rd_cs<=item.rd_cs;
        vif.rd_drv_cb.rd_en<=item.rd_en;
    endtask
endclass
