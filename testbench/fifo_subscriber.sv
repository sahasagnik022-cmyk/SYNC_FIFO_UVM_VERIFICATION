`uvm_analysis_imp_decl (_r)

class fifo_subscriber extends uvm_subscriber#(fifo_seq_item);
    `uvm_component_utils(fifo_subscriber)
    uvm_analysis_imp_r #(fifo_seq_item,fifo_subscriber)r_exp;
 
    fifo_seq_item w_xn;
    fifo_seq_item r_xn;
 
    covergroup cg1;
        cp_wr_cs: coverpoint w_xn.wr_cs{
            bins bwr_cs[] = {0,1};
        }
 
        cp_wr_en: coverpoint w_xn.wr_en{
            bins bwr_en[] = {0,1};
        }
        cp_data_in: coverpoint w_xn.data_in{
            bins low={[0:85]};
            bins med={[86:170]};
            bins high={[171:255]};
        } 
         
        wr_cs_en: cross cp_wr_cs,cp_wr_en;
    endgroup

    covergroup cg2;
        cp_rd_cs:coverpoint r_xn.rd_cs{
            bins brd_cs[]={0,1};
        }
        cp_rd_en:coverpoint r_xn.rd_en{
            bins brd_en[]={0,1};
        }
        cp_rd_en_cs: cross cp_rd_cs,cp_rd_en;
    endgroup

 
    function new(string name = "fifo_subscriber",uvm_component parent=null);
        super.new(name,parent);
        cg1=new();
        cg2=new();
        r_exp = new("r_exp",this);
    endfunction
 
    virtual function void write(fifo_seq_item t);
        w_xn = t;
        cg1.sample();
    endfunction
 
    virtual function void write_r(fifo_seq_item t);
        r_xn = t;
        cg2.sample();
    endfunction
 
endclass
