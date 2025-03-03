// `include "../tb/mem_if.sv"
class mem_driver extends uvm_driver#(mem_sequence_item);

    `uvm_component_utils(mem_driver)


    function new(string name = "mem_driver",uvm_component parent=null);
        super.new(name,parent);
    endfunction : new

    virtual mem_if vif;
    mem_sequence_item mem_txn;

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual mem_if)::get(uvm_root::get(), "*", "mem_vif", vif))
        `uvm_fatal(get_name(), "Could not get vif")
    endfunction



    
    task pre_reset_phase (uvm_phase phase);
        super.pre_reset_phase(phase);
		vif.wr_en <= 0;
		vif.rd_en <= 0;
	endtask

	task reset_phase(uvm_phase phase);
		phase.raise_objection(this);
		wait (vif.reset == 1'b1);
		`uvm_info(get_name(), $sformatf("after waiting for rstn to be asserted"), UVM_LOW)
   		phase.drop_objection(this);
	endtask : reset_phase

	task post_reset_phase(uvm_phase phase);
		phase.raise_objection(this);
    	wait (vif.reset == 1'b0);
    	`uvm_info(get_name(), $sformatf("after waiting for rstn to be deasserted"), UVM_LOW)
    	phase.drop_objection(this);
	endtask : post_reset_phase

    task main_phase (uvm_phase phase);
		`uvm_info(get_name(), $sformatf("enter in main_phase"), UVM_LOW)
		forever begin
			fork
				begin
					get_and_drive();
				end
			join_any
		end
	endtask : main_phase

    task get_and_drive();

        seq_item_port.get_next_item(mem_txn);

        vif.wr_en <= 0;
        vif.rd_en <= 0;

        $display("--------- [DRIVER-TRANSFER] ---------");

        @(posedge vif.DRIVER.clk);
        vif.DRIVER.driver_cb.addr <= mem_txn.addr;
        vif.DRIVER.driver_cb.wdata <= mem_txn.wdata;
        $display("\tADDR = %0h \tWDATA = %0h",mem_txn.addr,mem_txn.wdata);
        @(posedge vif.DRIVER.clk);

        if(mem_txn.wr_en) begin
            vif.DRIVER.driver_cb.wr_en <= mem_txn.wr_en;
            vif.DRIVER.driver_cb.wdata <= mem_txn.wdata;
            $display("\tADDR = %0h \tWDATA = %0h",mem_txn.addr,mem_txn.wdata);
            @(posedge vif.DRIVER.clk);
        end
        if(mem_txn.rd_en) begin
            vif.DRIVER.driver_cb.rd_en <= mem_txn.rd_en;
            @(posedge vif.DRIVER.clk);
            vif.DRIVER.driver_cb.rd_en <= 0;

            @(posedge vif.DRIVER.clk);
            mem_txn.rdata <= vif.MONITOR.monitor_cb.rdata;
            $display("\tADDR = %0h \tRDATA = %0h",mem_txn.addr,vif.MONITOR.monitor_cb.rdata);
        end
        $display("-----------------------------------------");
        seq_item_port.item_done();

    endtask
endclass


