
class mem_monitor extends uvm_monitor;
    
    `uvm_component_utils(mem_monitor)
    
    virtual mem_if vif;
    mem_sequence_item mem_txn; 
    
    uvm_analysis_port #(mem_sequence_item) mon_analysis_port;
    
    function new (string name = "mem_monitor", uvm_component parent );
        super.new(name, parent);
        mon_analysis_port = new("mon_analysis_port", this);
    endfunction
    
    
    
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual mem_if)::get(this, "", "mem_vif", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"}); 
    endfunction
    
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            mem_txn = mem_sequence_item::type_id::create("mem_txn");
            
            @(posedge vif.MONITOR.clk);
            wait(vif.monitor_cb.wr_en || vif.monitor_cb.rd_en);
            mem_txn.addr = vif.monitor_cb.addr;
            
            if(vif.monitor_cb.wr_en) begin
                mem_txn.wr_en = vif.monitor_cb.wr_en;
                mem_txn.wdata = vif.monitor_cb.wdata;
                mem_txn.rd_en = 0;
                @(posedge vif.MONITOR.clk);
            end
            
            if(vif.monitor_cb.rd_en) begin
                mem_txn.rd_en = vif.monitor_cb.rd_en;
                mem_txn.wr_en = 0;
                @(posedge vif.MONITOR.clk);
                @(posedge vif.MONITOR.clk);
                mem_txn.rdata = vif.monitor_cb.rdata;
            end
            mon_analysis_port.write(mem_txn);
        end 
    endtask : run_phase
    
    
endclass
