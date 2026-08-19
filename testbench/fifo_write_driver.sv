class fifo_write_driver extends uvm_driver #(fifo_seq_item);
    `uvm_component_utils(fifo_write_driver);
    virtual fifo_if vif;

    function new(string name="fifo_driver",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual fifo_if)::get(this,"","vif",vif))
        `uvm_fatal("DRV","Could not get virtual interface!")
    endfunction

    virtual task run_phase(uvm_phase phase);
        @(vif.wr_drv_cb);
        vif.wr_drv_cb.wr_cs<=0;
        vif.wr_drv_cb.wr_en<=0;
        vif.wr_drv_cb.data_in<='0;
        wait(!vif.rst); //Waiting for rst to go low
        forever begin
            seq_item_port.get_next_item(req);
            drive_item(req);
            seq_item_port.item_done();
            @(vif.wr_drv_cb);
            vif.wr_drv_cb.wr_en <= 0;
            vif.wr_drv_cb.wr_cs <= 0;
        end
    endtask
    virtual task drive_item(fifo_seq_item item);
        @(vif.wr_drv_cb);
        vif.wr_drv_cb.wr_cs<=item.wr_cs;
        vif.wr_drv_cb.wr_en<=item.wr_en;
        vif.wr_drv_cb.data_in<=item.data_in;
    endtask

endclass
